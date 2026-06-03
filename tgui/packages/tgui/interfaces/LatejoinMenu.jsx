import { Color } from 'tgui-core/color';
import {
  Box,
  Button,
  Section,
  Stack,
  StyleableSection,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export function LatejoinMenu(props) {
  const { act, data } = useBackend();
  const { round_duration } = data;

  return (
    <Window width={1012} height={725}>
      <Window.Content>
        <Section
          fill
          scrollable
          title={
            <Box as="span" color="label">
              It is currently {round_duration} into the night.
            </Box>
          }
        >
          <Box style={{ columns: '20em' }}>
            {Object.entries(data.departments).map(([name, department]) => (
              <DepartmentEntry key={name} name={name} department={department} />
            ))}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
}

function DepartmentEntry(props) {
  const { name, department } = props;
  const { act } = useBackend();

  return (
    <Box minWidth="30%">
      <StyleableSection
        title={
          <>
            {name}
            <span
              style={{
                fontSize: '1rem',
                whiteSpace: 'nowrap',
                position: 'absolute',
                right: '1em',
                color: Color.fromHex(department.color).toString(),
              }}
            >
              {department.open_slots +
                (department.open_slots === 1 ? ' slot' : ' slots') +
                ' available'}
            </span>
          </>
        }
        style={{
          border: `2px solid ${department.color}`,
          borderRadius: '0.16em',
          marginBottom: '1em',
          breakInside: 'avoid-column',
        }}
        titleStyle={{
          'border-bottom-color': Color.fromHex(department.color).toString(),
        }}
        textStyle={{
          color: Color.fromHex(department.color).toString(),
        }}
      >
        <Stack vertical>
          {Object.entries(department.jobs).map(([name, job]) => (
            <Stack.Item key={name}>
              <JobEntry
                key={name}
                jobName={name}
                job={job}
                department={department}
                onClick={() => {
                  act('select_job', { job: name });
                }}
              />
            </Stack.Item>
          ))}
        </Stack>
      </StyleableSection>
    </Box>
  );
}

function JobEntry(props) {
  const { jobName, job, department, onClick } = props;

  return (
    <Button
      fluid
      style={{
        backgroundColor: job.unavailable_reason
          ? '#949494'
          : job.prioritized
            ? '#16fc0f'
            : Color.fromHex(department.color).darken(10).toString(),
        color: job.unavailable_reason
          ? '#616161'
          : Color.fromHex(department.color).darken(90).toString(),
        fontSize: '1.1rem',
        cursor: job.unavailable_reason ? 'initial' : 'pointer',
      }}
      tooltip={
        job.unavailable_reason ||
        (job.prioritized ? (
          <>
            <p style={{ marginTop: '0px' }}>
              <b>The Prince wants more people in this job!</b>
            </p>
            {job.description}
          </>
        ) : (
          job.description
        ))
      }
      tooltipPosition="top"
      onClick={() => {
        !job.unavailable_reason && onClick();
      }}
    >
      <Stack fill>
        <Stack.Item grow>{job.command ? <b>{jobName}</b> : jobName}</Stack.Item>
        <Stack.Item>
          <span
            style={{
              whiteSpace: 'nowrap',
            }}
          >
            {job.used_slots} / {job.open_slots}
          </span>
        </Stack.Item>
      </Stack>
    </Button>
  );
}
