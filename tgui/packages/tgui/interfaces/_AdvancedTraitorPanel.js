import { useBackend, useSharedState } from '../backend';
import { Button, Divider, LabeledList, Section, Flex, Input, Box, TextArea, Tabs, RoundGauge, NumberInput, Tooltip } from '../components';
import { Window } from '../layouts';

export const _AdvancedTraitorPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    traitor_type,
    finalized_tc,
    goals_finalized,
    goals = [],
  } = data;
  return (
    <Window
      title="Advanced Traitor Panel"
      width={1150}
      height={550}
      theme='syndicate'>
      <Window.Content>
        <Section title={traitor_type === "AI" ? "Malfunctioning AI Background" : "Traitor Background"}>
          <_AdvancedTraitorPanel_Background />
        </Section>
        <Divider />
        <Section title={traitor_type === "AI" ? "Malfunctioning AI Objectives" : "Traitor Objectives"}>
          <Flex mb={1}>
            <Button
              width="85px"
              height="20px"
              icon="plus"
              content="Add Goal"
              textAlign="center"
              onClick={() => act('add_advanced_goal')}/>
            {goals_finalized === 0 && (
              <Button.Confirm
                width="112px"
                height="20px"
                icon="exclamation-circle"
                content="Finalize Goals"
                color="bad"
                textAlign="center"
                tooltip={traitor_type === "AI" ?
                  (`Finalizing will send you your uplink to your preferred location with ${{ finalized_tc }} telecrystals. You can still edit your goals after finalizing!`) :
                  (`Finalizing will begin installlation of your malfunction module with ${{ finalized_tc }} processing power. You can still edit your goals after finalizing!`)}
                onClick={() => act('finalize_goals')}/> )}
          </Flex>
          { !!goals.length && (
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
  const {
    goals = [],
  } = data;

  const [selectedGoalID, setSelectedGoal] = useSharedState(context, 'goals', goals[0]?.id);
  const selectedGoal = goals.find(goal => {
    return goal.id === selectedGoalID;
  });

  return (
  <Flex direction="column" grow={1}>
    { goals.length > 0 && (
      <Flex.Item>
         <Tabs>
          {goals.map(goal => (
            <Tabs.Tab
              selected={goal.id === selectedGoalID}
              onClick={() => setSelectedGoal(goal.id)}>
              Goal: {goal.id}
            </Tabs.Tab>
          ))}
        </Tabs>
      </Flex.Item>
    )}
    { !!selectedGoal ? (
      <Flex.Item>
        <Flex direction="column">
          <Flex>
            <Flex direction="column" mr={2} align="center">
              <Flex.Item mb={2} >
                Goal Text
              </Flex.Item>
              <Flex.Item>
                <TextArea
                  fluid
                  width="200px"
                  height="100px"
                  style={{'border-color': '#87ce87'}}
                  value={selectedGoal.goal}
                  placeholder={selectedGoal.goal}
                  onInput={(e, value) => act('set_goal_text', {
                    'goal_ref': selectedGoal.ref,
                    newgoal: value,
                  })} />
                </Flex.Item>
              </Flex>
            <Flex direction="column" mr={2} align="center">
              <Flex.Item mb={2}>
                Intensity
              </Flex.Item>
              <Flex.Item mb={2} position="relative">
                <RoundGauge
                  size={2}
                  value={selectedGoal.intensity}
                  minValue={1}
                  maxValue={5}
                  alertAfter={3.9}
                  format={value => null}
                  ranges={{
                    "green": [1, 1.8],
                    "good": [1.8, 2.6],
                    "yellow": [2.6, 3.4],
                    "orange": [3.4, 4.2],
                    "red": [4.2, 5], }} />
                <Tooltip
                  content="Set your goal's intensity level."/>
              </Flex.Item>
              <Flex.Item>
                <NumberInput
                  value={selectedGoal.intensity}
                  step={1}
                  minValue={1}
                  maxValue={5}
                  stepPixelDrag={10}
                  onChange={(e, value) => act('set_goal_intensity', {
                    'goal_ref': selectedGoal.ref,
                    newlevel: value,
                  })}  />
              </Flex.Item>
            </Flex>
            <Flex direction="column" mr={2} align="center">
              <Flex.Item mb={2}>
                Additional Notes
              </Flex.Item>
              <Flex.Item>
                <TextArea
                  width="200px"
                  height="100px"
                  style={{'border-color': '#87ce87'}}
                  value={selectedGoal.notes}
                  placeholder={selectedGoal.notes}
                  onInput={(e, value) => act('set_note_text', {
                    'goal_ref': selectedGoal.ref,
                    newtext: value,
                  })} />
              </Flex.Item>
            </Flex>
            <Flex direction="column" mr={2} align="center">
              <Flex.Item mb={2}>
                <Flex direction="column" width="300px">
                  <Flex.Item mb={2} align="center">
                    Similar Objectives
                  </Flex.Item>
                  <Flex.Item align="center">
                    <Button.Checkbox
                      content="Check All"
                      width="85px"
                      height="20px"
                      tooltip={selectedGoal.check_all_objectives ? ("Currently, success is determined on all objectives succeeding.") : ("Currently, success is determined on any one of the objectives succeeding.")}
                      checked={selectedGoal.check_all_objectives}
                      onClick={() => act('toggle_check_all_objectives', {'goal_ref': selectedGoal.ref})} />
                    <Button.Checkbox
                      content="Always Succeed"
                      width="130px"
                      height="20px"
                      tooltip={selectedGoal.always_succeed ? ("Currently, this objective will always be marked as a success, even if no objectives are set.") : ("Currently, success of this objective will depend on success of the objectives below. If no objectives are set, no success or failure text will be displayed at all.")}
                      checked={selectedGoal.always_succeed}
                      onClick={() => act('toggle_always_succeed', {'goal_ref': selectedGoal.ref})} />
                  </Flex.Item>
                </Flex>
              </Flex.Item>
              <Flex.Item>
                <Flex direction="column">
                  {selectedGoal.objective_data.map(objective => (
                    <Flex.Item >
                      <Button
                        content="Remove Objective"
                        color="bad"
                        onClick={() => act('remove_similar_objective', {'goal_ref': selectedGoal.ref, 'objective_ref': objective.ref})}/>
                      : {objective.text}
                    </Flex.Item>))}
                  </Flex>
              </Flex.Item>
              <Flex.Item>
                <Button
                  width="160px"
                  height="20px"
                  icon="plus"
                  content="Add Similar Objective"
                  textAlign="center"
                  onClick={() => act('add_similar_objective', {'goal_ref': selectedGoal.ref})}/>
                { !!selectedGoal.objective_data.length && (
                  <Button.Confirm
                    width="210px"
                    height="20px"
                    icon="minus"
                    content="Remove All Similar Objectives"
                    color="bad"
                    textAlign="center"
                    onClick={() => act('clear_sim_objectives', {'goal_ref': selectedGoal.ref})}/>)}
              </Flex.Item>
            </Flex>
          </Flex>
          <Flex ml={3}>
            <Button.Confirm
              width="160px"
              height="20px"
              icon="minus"
              content={`Remove Goal ${ selectedGoal.id }`}
              color="bad"
              textAlign="center"
              onClick={() => act('remove_advanced_goal', {'goal_ref': selectedGoal.ref})}/>
          </Flex>
        </Flex>
      </Flex.Item>
      ) : (
      <Box>
        No goals added.
      </Box>
      )}
  </Flex>
  );
};
