trigger OrderTrig on Order (after insert) {
	if (Trigger.isInsert && Trigger.isAfter) {
		OrderTriggerHandler.AssignOrderLineItems(Trigger.New);
	}
}