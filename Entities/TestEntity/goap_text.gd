extends Label

func visualize_agent(agent:GOAPAgent)->void:
	text = ""
	
	text += "Current Goal : "
	if agent._current_goal:
		text += agent._current_goal.goal_name()
	
	text += "\nCurrent Plan"
	if agent._current_plan:
		text += " [%d] : "%agent._current_plan.get_current_step()
		text += agent._current_plan.str_actions()
	
	text += "\nCurrent Action : "
	if agent._current_plan and agent._current_plan.get_current_action():
		text += agent._current_plan.get_current_action().action_name()
	
	text += "\nLocalWorld : "
	text += agent._local_world.str_state()
