import { useBackend, useSharedState } from '../backend';
import { Button, Divider, LabeledList, Section, Flex, Input, Box, TextArea, Tabs, RoundGauge, NumberInput } from '../components';
import { Window } from '../layouts';

export const _AdvancedTraitorPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    goals_finalized,
    goals = [],
  } = data;
  return (
    <Window
      title="Advanced Traitor Panel"
      width={800}
      height={500}
      theme='syndicate'>
      <Window.Content>
        <Section title="Traitor Background">
          <_AdvancedTraitorPanel_Background />
        </Section>
        <Divider />
        <Section title="Traitor Objectives">
          <Flex mb={1}>
            <Button
              width="85px"
              height="20px"
              icon="plus"
              content="Add Goal"
              onClick={() => act('add_advanced_goal')}/>
            {goals_finalized === 0 && (
              <Button
                width="112px"
                height="20px"
                icon="exclamation-circle"
                content="Finalize Goals"
                color="bad"
                onClick={() => act('finalize_goals')}/> )}
          </Flex>
          {!goals.length ? (
              <Box>
                No Goals
              </Box>
            ) : (
              <_AdvancedTraitorPanel_Goals />
            )}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const _AdvancedTraitorPanel_Background = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    name,
    employer,
    backstory,
  } = data;
  return (
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
  );
};

export const _AdvancedTraitorPanel_Goals = (props, context) => {
  const { act, data } = useBackend(context);
  const [selectedGoalID, setSelectedGoal] = useSharedState(context, 'goals', 1);
  const selectedGoal = goals.find(goal => {
    return goal.id === selectedGoalID;
  });

  const {
    goals = [],
  } = data;
  return (
  <Flex>
    <Tabs>
      {goals.map(goal => (
        <Tabs.Tab
          selected={goal.id === selectedGoalID}
          onClick={() => setSelectedGoal(goal.id)}>
          Goal: {goal.id}
        </Tabs.Tab>
      ))}
    </Tabs>
    <Flex>
      { selectedGoal ? (
        <Flex>
          <TextArea
            fluid
            width="100%"
            height="100px"
            style={{'border-color': '#87ce87'}}
            value={selectedGoal.goal}
            onInput={(e, value) => act('set_goal_text', {
              'ref': selectedGoal.ref,
              newgoal: value,
            })}
          placeholder={selectedGoal.goal} />
          <RoundGauge
            size={2}
            value={selectedGoal.intensity}
            minValue={1}
            maxValue={5}
            alertAfter={3.9}
            scale={1}
            ranges={{
              "green": [0, 1],
              "good": [1, 2],
              "yellow": [2, 3],
              "orange": [3, 4],
              "red": [4, 5], }} />
          <NumberInput
            value={selectedGoal.intensity}
            step={1}
            minValue={1}
            maxValue={5} />
        </Flex>
        ) : (
        <Box>
          No selected goals. Press "Add Goals" to make some.
        </Box>
      )}
    </Flex>
  </Flex>
  );
};
