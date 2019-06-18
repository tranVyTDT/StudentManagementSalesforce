@isTest
private class TriggerStudentTest
{

	@isTest
	static void TestTriggerHandle()
	{
		// Create common test classes and students
        List<Class__c> testClass = new List<Class__c>();
        testClass.add(new Class__c(className__c = 'English'));
        testClass.add(new Class__c(className__c = 'Math'));
        testClass.add(new Class__c(className__c = 'Physics'));
        testClass.add(new Class__c(className__c = 'Chemistry'));

        insert testClass;

        Class__c classMath = [SELECT id FROM Class__c Where className__c = 'Chemistry'];
        
        List<Student__c> testStudent= new List<Student__c>();
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

		Test.startTest();

		List<Student__c> studentList = [select id , Name , State__c from Student__c];

		for(Student__c s : studentList)
		{
			if(s.State__c.equalsIgnoreCase('passed'))
			{
				delete s;
				break;
			}
		}
		Class__c classChemistry = [select id , 
									NumberOfStudents__c, 	
									NumberOfPassedStudents__c, 	
									NumberOfFailedStudents__c
								from Class__c
								where className__c = 'Chemistry'];
		
		System.assertEquals(classChemistry.NumberOfStudents__c,4);
		System.assertEquals(classChemistry.NumberOfFailedStudents__c,2);
		System.assertEquals(classChemistry.NumberOfPassedStudents__c,2);

		studentList = [select id , Name , State__c from Student__c];

		for(Student__c s : studentList)
		{
			s.Score3__c = 0;

			update s;
		}

		classChemistry = [select id , 
									NumberOfStudents__c, 	
									NumberOfPassedStudents__c, 	
									NumberOfFailedStudents__c
								from Class__c
								where className__c = 'Chemistry'];
		
		System.assertEquals(classChemistry.NumberOfFailedStudents__c,4);
		System.assertEquals(classChemistry.NumberOfPassedStudents__c,0);

		studentList = [select id , Name , State__c from Student__c];

		for(Student__c s : studentList)
		{
			s.Score3__c = 10;
			s.Score1__c = 10;

			update s;
		}

		classChemistry = [select id , 
									NumberOfStudents__c, 	
									NumberOfPassedStudents__c, 	
									NumberOfFailedStudents__c
								from Class__c
								where className__c = 'Chemistry'];

		System.assertEquals(classChemistry.NumberOfFailedStudents__c,0);
		System.assertEquals(classChemistry.NumberOfPassedStudents__c,4);


		Test.stopTest();
	}
}