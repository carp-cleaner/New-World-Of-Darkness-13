import { Icon, Section, Table, Tooltip } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

const commandJobs = [
  'Prince',
  'Baron',
  'Chantry Regent',
  'Police Chief',
  'Dealer',
  'Capo',
];

export const CrewManifest = (props) => {
  const {
    data: { manifest },
  } = useBackend();

  return (
    <Window title="City Population" width={350} height={500}>
      <Window.Content scrollable>
        {Object.entries(manifest).map(([dept, crew]) => (
          <Section
            className={`CrewManifest--${dept.replace(' ', '')}`}
            key={dept}
            title={dept}
          >
            <Table>
              {Object.entries(crew).map(([crewIndex, crewMember]) => (
                <Table.Row key={crewIndex}>
                  <Table.Cell
                    className={'CrewManifest__Cell'}
                    maxWidth="135px"
                    overflow="hidden"
                    width="50%"
                  >
                    {crewMember.name}
                  </Table.Cell>
                  <Table.Cell
                    className={classes([
                      'CrewManifest__Cell',
                      'CrewManifest__Icons',
                    ])}
                    collapsing
                    minWidth="40px"
                    width="40px"
                  >
                    {crewMember.rank === 'Prince' ? (
                      <Tooltip content="Prince" position="bottom">
                        <Icon
                          className={classes([
                            'CrewManifest__Icon',
                            'CrewManifest__Icon--Command',
                          ])}
                          name="star"
                        />
                      </Tooltip>
                    ) : (
                      commandJobs.includes(crewMember.rank) && (
                        <Tooltip content="Member of leaders" position="bottom">
                          <Icon
                            className={classes([
                              'CrewManifest__Icon',
                              'CrewManifest__Icon--Command',
                              'CrewManifest__Icon--Chevron',
                            ])}
                            name="chevron-up"
                          />
                        </Tooltip>
                      )
                    )}
                  </Table.Cell>
                  <Table.Cell
                    className={classes([
                      'CrewManifest__Cell',
                      'CrewManifest__Cell--Rank',
                    ])}
                    collapsing
                    maxWidth="135px"
                    overflow="hidden"
                    width="50%"
                  >
                    {crewMember.rank}
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};
