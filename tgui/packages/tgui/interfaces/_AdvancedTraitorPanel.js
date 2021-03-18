import { useBackend } from '../backend';
import { Button, Divider, LabeledList, Section, Flex, Input, Box, TextArea } from '../components';
import { Window } from '../layouts';

export const _AdvancedTraitorPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    name,
    employer,
    backstory,
  } = data;
  return (
    <Window
      title="Advanced Traitor Panel"
      width={800}
      height={500}
      theme='syndicate'>
      <Window.Content>
        <Section title="Traitor Background">
          <Flex>
            <Flex.Item width={30}>
              <Flex direction="column">
                <Flex.Item mb={1}>
                  <Box mb={1}>Name:</Box>
                  <Input
                    width="250px"
                    value={name}
                    onInput={(e, value) => act('set_name', {
                      name: value,
                    })}
                    placeholder={name} />
                </Flex.Item>
                <Flex.Item mb={1}>
                  <Box mb={1}>Employer:</Box>
                  <Input
                    width="250px"
                    value={employer}
                    onInput={(e, value) => act('set_employer', {
                      employer: value,
                    })}
                    placeholder={employer} />
                </Flex.Item>
              </Flex>
            </Flex.Item>
            <Flex.Item grow={1} mb={1}>
              <Box width="40px" mb={1}>Backstory:</Box>
              <TextArea
                fluid
                width="100%"
                height="100px"
                style={{'border-color': '#87ce87'}}
                value={backstory}
                onInput={(e, value) => act('set_backstory', {
                  backstory: value,
                })}
                placeholder={backstory} />
            </Flex.Item>
          </Flex>
        </Section>
        <Divider />
        <Section title="Traitor Objectives">
          <Button
            icon="plus"
            content="Add Goal"
            onClick={() => act('add_advanced_goal')}/>
          <Button
            icon="exclamation-circle"
            content="Finalize Goals"
            color="bad"
            onClick={() => act('finalize_goals')}/>
        </Section>
      </Window.Content>
    </Window>
  );
};
