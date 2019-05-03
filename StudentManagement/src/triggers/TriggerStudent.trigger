trigger triggerStudent on Student__c (before insert 
									,after insert, after delete, after update) {
	TriggerStudent handle = new TriggerStudent();
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
}