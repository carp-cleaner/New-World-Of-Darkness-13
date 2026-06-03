import fnmatch
import glob
import os
import re
import sys
from collections import defaultdict

parent_directory = "code/**/*.dm"

output_file_name = "define_sanity_output.txt"

def green(text):
    return "\033[32m" + str(text) + "\033[0m"

def red(text):
    return "\033[31m" + str(text) + "\033[0m"

def blue(text):
    return "\033[34m" + str(text) + "\033[0m"

def yellow(text):
    return "\033[33m" + str(text) + "\033[0m"

# simple way to check if we're running on github actions, or on a local machine
on_github = os.getenv("GITHUB_ACTIONS") == "true"

# This files/directories are expected to have "global" defines, so they must be exempt from this check.
# Add directories as string here to automatically be exempt in case you have a non-complaint file name.
excluded_files = [
    #  Wildcard directories, all files are expected to be exempt.
    "code/__DEFINES/*.dm",
    "code/__HELPERS/*.dm",
    "code/_globalvars/*.dm",
    # TGS files come from another repository so lets not worry about them.
    "code/modules/tgs/**/*.dm",
]

# Regex для поиска дефайнов
define_regex = re.compile(r"(\s+)?#define\s+([A-Z0-9_]+)(?:\(.*?\))?\s")
# Regex для поиска использования дефайнов (включая определения)
usage_regex = re.compile(r"\b([A-Z0-9_]+)\b")
# Regex для поиска #undef
undef_regex = re.compile(r"#undef\s+([A-Z0-9_]+)")

def get_files_to_scan():
    """Получить список файлов для сканирования, исключая exempt файлы"""
    files_to_scan = []

    for code_file in glob.glob(parent_directory, recursive=True):
        exempt_file = False
        for exempt_directory in excluded_files:
            if fnmatch.fnmatch(code_file, exempt_directory):
                exempt_file = True
                break

        if exempt_file:
            continue

        # If the "base path" of the file starts with an underscore, it's assumed to be an encapsulated file holding references to the other files in its folder and is exempt from the checks.
        if os.path.basename(code_file)[0] == "_":
            continue

        files_to_scan.append(code_file)

    return files_to_scan

def scan_all_defines_and_usages(files_to_scan):
    """Сканировать все файлы и найти дефайны и их использования"""
    define_locations = defaultdict(list)  # define_name -> [file_paths where it's defined]
    define_usages = defaultdict(set)      # define_name -> {file_paths where it's used}
    file_defines = defaultdict(list)     # file_path -> [define_names defined in this file]
    file_undefs = defaultdict(set)       # file_path -> {define_names that are undefined in this file}

    print(blue("Scanning files for defines and usages..."))

    for file_path in files_to_scan:
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                content = file.read()

                # Найти все дефайны в файле
                for match in define_regex.finditer(content):
                    define_name = match.group(2)
                    define_locations[define_name].append(file_path)
                    file_defines[file_path].append(define_name)

                # Найти все #undef в файле
                for match in undef_regex.finditer(content):
                    undef_name = match.group(1)
                    file_undefs[file_path].add(undef_name)

                # Найти все использования дефайнов в файле
                for match in usage_regex.finditer(content):
                    potential_define = match.group(1)
                    # Проверяем, что это потенциальный дефайн (начинается с заглавной буквы и содержит подчеркивания)
                    if potential_define.isupper() and len(potential_define) > 1:
                        define_usages[potential_define].add(file_path)

        except Exception as e:
            print(red(f"Error reading file {file_path}: {e}"))
            continue

    return define_locations, define_usages, file_defines, file_undefs

def find_local_defines(define_locations, define_usages):
    """Найти локальные дефайны (используются только в одном файле)"""
    local_defines = {}  # define_name -> file_path

    for define_name, definition_files in define_locations.items():
        # Получить все файлы, где используется этот дефайн
        usage_files = define_usages.get(define_name, set())

        # Если дефайн используется только в одном файле, и он определен только в одном файле,
        # и это один и тот же файл - то это локальный дефайн
        if len(definition_files) == 1 and len(usage_files) == 1:
            definition_file = definition_files[0]
            usage_file = list(usage_files)[0]

            if definition_file == usage_file:
                local_defines[define_name] = definition_file

    return local_defines

def add_undefs_to_files(local_defines, file_undefs):
    """Добавить #undef в конец файлов для локальных дефайнов"""
    files_modified = 0
    defines_added = 0

    # Группируем дефайны по файлам
    files_to_modify = defaultdict(list)
    for define_name, file_path in local_defines.items():
        # Проверяем, что #undef еще не существует для этого дефайна
        if define_name not in file_undefs.get(file_path, set()):
            files_to_modify[file_path].append(define_name)

    for file_path, defines_to_undef in files_to_modify.items():
        if not defines_to_undef:
            continue

        try:
            # Читаем файл
            with open(file_path, 'r', encoding='utf-8') as file:
                content = file.read()

            # Подготавливаем #undef строки
            undef_lines = []
            for define_name in sorted(defines_to_undef):
                undef_lines.append(f"#undef {define_name}")

            # Добавляем #undef в конец файла
            if content and not content.endswith('\n'):
                content += '\n'

            content += '\n' + '\n'.join(undef_lines) + '\n'

            # Записываем измененный файл
            with open(file_path, 'w', encoding='utf-8') as file:
                file.write(content)

            files_modified += 1
            defines_added += len(defines_to_undef)

            print(green(f"✓ Modified {file_path}: added {len(defines_to_undef)} #undef statements"))
            for define_name in sorted(defines_to_undef):
                print(f"  - #undef {define_name}")

        except Exception as e:
            print(red(f"Error modifying file {file_path}: {e}"))
            continue

    return files_modified, defines_added

def main():
    if not on_github:
        print(blue("Running define sanity auto-fix tool..."))

    # Получить список файлов для сканирования
    files_to_scan = get_files_to_scan()

    if not files_to_scan:
        print(red("No files found to scan!"))
        sys.exit(1)

    print(f"Found {len(files_to_scan)} files to scan")

    # Сканировать все дефайны и их использования
    define_locations, define_usages, file_defines, file_undefs = scan_all_defines_and_usages(files_to_scan)

    total_defines = len(define_locations)
    print(f"Found {total_defines} unique defines")

    if total_defines == 0:
        print(red("No defines found! This is likely an error."))
        sys.exit(1)

    if total_defines <= 100:
        print(yellow(f"Warning: Only found {total_defines} defines! This seems low."))

    # Найти локальные дефайны
    local_defines = find_local_defines(define_locations, define_usages)

    print(f"Found {len(local_defines)} local defines that need #undef")

    if not local_defines:
        print(green("No local defines found that need #undef statements!"))
        return

    # Показать, что будет изменено
    print(yellow("\nLocal defines that will get #undef added:"))
    for define_name, file_path in sorted(local_defines.items()):
        if define_name not in file_undefs.get(file_path, set()):
            print(f"  - {define_name} in {file_path}")

    # Спросить подтверждение, если не на GitHub Actions
    if not on_github:
        response = input(f"\nDo you want to add #undef statements to {len(local_defines)} local defines? (y/N): ").strip().lower()
        if response not in ['y', 'yes']:
            print("Operation cancelled.")
            return

    # Добавить #undef в файлы
    files_modified, defines_added = add_undefs_to_files(local_defines, file_undefs)

    print(green(f"\n✓ Successfully modified {files_modified} files"))
    print(green(f"✓ Added {defines_added} #undef statements"))

    if files_modified > 0:
        print(blue("\nRecommendation: Review the changes and run your build system to ensure everything still works correctly."))

if __name__ == "__main__":
    main()
