@isTest
private class testBatch
{
	@testSetup static void setup() {
        // Create common test classes and students
        List<Class__c> testClass = new List<Class__c>();
        testClass.add(new Class__c(className__c = 'English'));
        testClass.add(new Class__c(className__c = 'Math'));
        testClass.add(new Class__c(className__c = 'Physics'));
        testClass.add(new Class__c(className__c = 'Chemistry'));
        insert testClass;
    }

    @isTest
    static void testBatchSchedule()
    {
    	// CRON expression: midnight on March 15. Because this is a test, 
	    // job is supposed to execute immediately after Test.stopTest()
	    String cronExpr = '0 0 0 15 3 ? 2022';

	    // NB: test data not needed, because we're not testing Apex Batch results
	    // That will be tested somewhere else

	    // Verify that AsyncApexJob is empty
	    // not strictly necessary but makes what is going on later clearer
	    List<AsyncApexJob> jobsBefore = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob];
	    System.assertEquals(0, jobsBefore.size(), 'not expecting any asyncjobs');

	    Test.startTest();
	    // Schedule the test job
	    String jobId = System.schedule('ImportDataPatch', cronExpr, new ImportDataScheduleBatch());
	    Test.stopTest();

	    // There will now be two things in AsyncApexJob - the Schedulable itself
	    // and also the Batch Apex job. This code looks for both of them

	    // Check schedulable is in the job list
	    List<AsyncApexJob> jobsScheduled = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'ScheduledApex'];
	    System.assertEquals(1, jobsScheduled.size(), 'expecting one scheduled job');
	    System.assertEquals('ImportDataScheduleBatch', jobsScheduled[0].ApexClass.Name, 'expecting specific scheduled job');

	    // check apex batch is in the job list
	    List<AsyncApexJob> jobsApexBatch = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'BatchApex'];
	    System.assertEquals(1, jobsApexBatch.size(), 'expecting one apex batch job');
	    System.assertEquals('ImportDataPatch', jobsApexBatch[0].ApexClass.Name, 'expecting specific batch job');

    }
	@isTest
	static void testImportDataPatch()
	{
		Test.startTest();

		Class__c classMath = [SELECT id FROM Class__c Where className__c = 'Chemistry'];
		Student__c s = new Student__c();
		s.Name = 'test batch';
		s.Birthday__c = Date.newInstance(2011, 3, 21);
		s.Score1__c = 4;
		s.Score2__c = 5;
		s.Score3__c = 6;
		s.Class__c = classMath.id;

		insert s;

		Database.executeBatch(new ImportDataPatch());

		s = [select id from Student__c where Name = 'test batch'];
		List<Score__c> scoreList = [select Course__c , Score__c from Score__c where Student__c =: s.id];
		for(Score__c score :scoreList)
		{
			if(score.Course__c.equals('Math'))
			{
				System.assertEquals(score.Score__c,4);
			} 
			else if(score.Course__c.equals('Chemistry'))
			{
				System.assertEquals(score.Score__c,5);
			} 
			else if(score.Course__c.equals('Physical'))
			{
				System.assertEquals(score.Score__c,6);
			}
		}

		Test.stopTest();

	}
}