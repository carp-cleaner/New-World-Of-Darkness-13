import { Button, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const AboutMePanel = (props) => {
  const { act, data } = useBackend();
  return (
    <Window title="About me" width={400} height={500}>
      <Window.Content scrollable>
        <Section>
          I am {data.name}, the {data.affiliation}. Carrying the {data.role}{' '}
          {data.special_role && (
            <span style={{ color: 'red' }}>{data.special_role}</span>
          )}{' '}
          role
        </Section>
        {data.info.map(
          (i, infoIndex) =>
            i.values.len !== 0 && (
              <Section
                title={i.name}
                key={`${i.name}_section_${infoIndex}`}
                buttons={
                  <Button
                    color="transparent"
                    tooltip={i.tooltip}
                    tooltipPosition="bottom-start"
                    icon="info"
                  />
                }
              >
                <Stack vertical>
                  {i.values.map((value, index) => (
                    <Stack.Item key={`${i.name}_${index}`}>
                      <Section>{value}</Section>
                    </Stack.Item>
                  ))}
                </Stack>
              </Section>
            ),
        )}
      </Window.Content>
    </Window>
  );
};
