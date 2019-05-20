global class ImportDataPatch implements Database.Batchable<sObject>, Database.Stateful {
	
	global ImportDataPatch() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {

		return Database.getQueryLocator([SELECT 
					st.id
					,st.Score1__c
					,st.Score2__c
					,st.Score3__c	
					FROM Student__c AS st
					WHERE st.id NOT IN
						(SELECT 
						s.Student__c
						FROM Score__c AS s)]);
	}

   	global void execute(Database.BatchableContext BC, List<Student__c> scope) {
   		List<Score__c> courseList = new List<Score__c>();

		for(Student__c s : scope)
		{
			//generate courses for each student
			Score__c math = new Score__c();
			math.Course__c = 'Math';
			Score__c chemistry = new Score__c();
			chemistry.Course__c = 'Chemistry';
			Score__c physical = new Score__c();
			physical.Course__c = 'Physical';
			//put data into courses
			math.Student__c = chemistry.Student__c = physical.Student__c = s.id;
			math.Score__c = s.Score1__c;
			chemistry.Score__c = s.Score2__c;
			physical.Score__c = s.Score3__c;
			//add course into list to update only once
			courseList.add(math);
			courseList.add(chemistry);
			courseList.add(physical);
		}

		insert courseList;
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}