@isTest
private class StudentDetailsControllerTest
{
	@testSetup static void setup() {
        // Create common test classes and students
        List<Class__c> testClass = new List<Class__c>();
        testClass.add(new Class__c(className__c = 'English'));
        testClass.add(new Class__c(className__c = 'Math'));
        testClass.add(new Class__c(className__c = 'Physics'));
        testClass.add(new Class__c(className__c = 'Chemistry'));
        insert testClass;
        Class__c classMath = [SELECT id FROM Class__c Where className__c = 'Chemistry'];
        List<Student__c> testStudent= new List<Student__c>();
        System.debug(testClass.get(1).id);
        testStudent.add(new Student__c(Name = 'truong vy 1'
        							, Namef__c = 'vy 1' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 9
						        	, Class__c = classMath.id));

		testStudent.add(new Student__c(Name = 'truong vy 2'
									, Namef__c = 'vy 2' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 9
						        	, Class__c = classMath.id)); 

		testStudent.add(new Student__c(Name = 'truong vy 3'
									, Namef__c = 'vy 3' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 9
						        	, Class__c = classMath.id)); 

		testStudent.add(new Student__c(Name = 'truong vy 4'
									, Namef__c = 'vy 4' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 0
						        	, Class__c = classMath.id));   

		testStudent.add(new Student__c(Name = 'truong vy 5'
									, Namef__c = 'vy 5' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 0
						        	, Score3__c = 9
						        	, Class__c = classMath.id));
		insert testStudent;
    }

	@isTest
	static void testStudentDetailsController()
	{
		
		Test.startTest();
		Test.setCurrentPage(Page.MainPage);
		Student__c s = [select id from Student__c where Namef__c = 'vy 1'];
		System.debug(s.id);
		Test.setCurrentPage(new PageReference('/apex/StudentDetails?id=' + s.id));
		try
		{
			StudentDetailsController studentDetailsController = new StudentDetailsController();
			studentDetailsController.goBack();

			PageReference pageReference = Page.StudentDetails;
			Test.setCurrentPage(pageReference);
			pageReference.getParameters().put('id',s.id);
			studentDetailsController.goUpdate();
			
			System.assert(true);
		}
		catch(Exception ex)
		{
			System.debug(ex.getMessage());
			System.assert(false);
		}
	}

	@isTest
	static void testActionDeleteStudent()
	{
		Test.startTest();

		Student__c s = [select id from Student__c where Namef__c = 'vy 1'];

		PageReference pageReference = Page.StudentDetails;
		Test.setCurrentPage(pageReference);
		pageReference.getParameters().put('id',s.id);

		StudentDetailsController studentDetailsController = new StudentDetailsController();
		studentDetailsController.actionDeleteStudent();
		Student__c queryResult = [select id , IsDeleted from Student__c where Namef__c = 'vy 1' ALL ROWS];
		System.assertEquals(queryResult.IsDeleted,true);
		Test.stopTest();
	}
}