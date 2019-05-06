trigger triggerStudent on Student__c (before insert 
									,after insert, after delete, after update) {
	TriggerHandle handle = new TriggerHandle();
	if(Trigger.isBefore)
	{	
		//check date input is blank
		//check age is valied
		//check score1 score2 score3 are filled
		if(Trigger.isInsert)
		{
			handle.onBeforeInsert(Trigger.new);
		}
	}
	else
	{
		if(Trigger.isInsert)
		{
			handle.onAfterInsert(Trigger.new);
		} 
		else if(Trigger.isDelete)
		{
			handle.onAfterDelete(Trigger.old);
		} else if(Trigger.isUpdate)
		{
			handle.onAfterUpdate(Trigger.new);
		}
	}
}