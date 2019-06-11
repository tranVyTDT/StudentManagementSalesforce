@isTest
private class Controller_test
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
	static void testGetItems()
	{
		Controller controller = new Controller();
		List<SelectOption> optionsComparison = new List<SelectOption>();
		List<SelectOption> optionsQuery = new List<SelectOption>();
		optionsComparison.add(new SelectOption('English','English'));
		optionsComparison.add(new SelectOption('Math','Math'));
		optionsComparison.add(new SelectOption('Physics','Physics'));
		optionsComparison.add(new SelectOption('Chemistry','Chemistry'));

		Test.startTest();
		optionsQuery = controller.getItems();
		Test.stopTest();
		
		System.assertEquals(optionsComparison, optionsQuery);
	}

	@isTest
	static void testGetStudent()
	{
		Controller controller = new Controller();
		List<controller.StudentDTO> studentComparison = new list<controller.StudentDTO>();
		List<controller.StudentDTO> studentQuery = new list<controller.StudentDTO>();
		//setup conditions for searching students
		controller.objKeySearch.increasing = true;
		controller.objKeySearch.studentName = new Student__c(Name = 'zzz');
		controller.objKeySearch.className = 'Chemistry';
		controller.objKeySearch.objStudentTo = new Student__c(Birthday__c = Date.newInstance(2000, 1, 1));
		controller.objKeySearch.objStudentFrom = new Student__c(Birthday__c = Date.newInstance(2000, 1, 1));
		
		Test.startTest();
		controller.actionSearch();
		/// test actionDeleteStudent

		Student__c s1 = [select id from Student__c where Namef__c = 'vy 1'];

		PageReference pageReference = Page.MainPage;
		Test.setCurrentPage(pageReference);
		pageReference.getParameters().put('idStudent',s1.id);

		controller.actionDeleteStudent();

		Student__c queryResult = [select id , IsDeleted from Student__c where Namef__c = 'vy 1' ALL ROWS];

		System.assertEquals(queryResult.IsDeleted, true);

		///
		List<Student__c> studentGetList = [SELECT Namef__c
												,Namel__c
												,Birthday__c
												,Gender__c
												,Score1__c
												,Score2__c
												,Score3__c
												,AverageScore__c
												,State__c
												,StudentId__c
												,Student__c.Class__c
										FROM Student__c];
		Test.stopTest();

		//setup studentComparison
		for(Student__c s : studentGetList)
		{
			studentComparison.add(new controller.StudentDTO(s));
		}
		
		Controller_test a = new Controller_test();
		List<controller.StudentDTO> result = a.sort(studentComparison, true);
		for(Integer i = 0 ; i < controller.objStudentList.size() ; i++)
		{
			System.assertEquals(result.get(i).student.Namef__c ,controller.objStudentList.get(i).student.Namef__c);
			System.assertEquals(result.get(i).student.Namel__c ,controller.objStudentList.get(i).student.Namel__c);
			System.assertEquals(result.get(i).student.Birthday__c ,controller.objStudentList.get(i).student.Birthday__c);
			System.assertEquals(result.get(i).student.Gender__c ,controller.objStudentList.get(i).student.Gender__c);
			System.assertEquals(result.get(i).student.Score1__c ,controller.objStudentList.get(i).student.Score1__c);
			System.assertEquals(result.get(i).student.Score2__c ,controller.objStudentList.get(i).student.Score2__c);
			System.assertEquals(result.get(i).student.Score3__c ,controller.objStudentList.get(i).student.Score3__c);
			System.assertEquals(result.get(i).student.State__c ,controller.objStudentList.get(i).student.State__c);
			System.assertEquals(result.get(i).student.StudentId__c ,controller.objStudentList.get(i).student.StudentId__c);
			System.assertEquals(result.get(i).student.Class__c ,controller.objStudentList.get(i).student.Class__c);
		}
	}

	@isTest
	static void testDoDetails()
	{
		Controller controller = new Controller();
		Student__c  s = [select ID  from Student__c where Namef__c = 'vy 4'];
		controller.idStudent = s.id ;
		try
		{
			controller.doDetails();
			System.assert(true);
		}
		catch(Exception ex)
		{
			System.assert(false);
		}
	}

	@isTest
	static void testGoUpdateStudent()
	{
		Controller controller = new Controller();
		Student__c  s = [select ID  from Student__c where Namef__c = 'vy 4'];
		controller.idStudent = s.id ;
		try
		{
			controller.goUpdateStudent();
			System.assert(true);
		}
		catch(Exception ex)
		{
			System.assert(false);
		}
	}

	@isTest
	static void testDoSubmit()
	{
		Controller controller = new Controller();
		Student__c  s = [select ID  from Student__c where Namef__c = 'vy 4'];
		controller.idStudent = s.id ;
		try
		{
			controller.doSubmit();
			System.assert(true);
		}
		catch(Exception ex)
		{
			System.assert(false);
		}
	}

	@isTest
	static void testGoBack()
	{
		Controller controller = new Controller();
		Student__c  s = [select ID  from Student__c where Namef__c = 'vy 4'];
		controller.idStudent = s.id ;
		try
		{
			controller.goBack();
			System.assert(true);
		}
		catch(Exception ex)
		{
			System.assert(false);
		}
	}

	@isTest
	static void testDoInsert()
	{
		Controller controller = new Controller();
		controller.student.Namef__c = 'vy 6';
		controller.student.Namel__c = 'truong';
		controller.student.Gender__c = false;
		controller.student.Birthday__c = Date.newInstance(2010, 9, 4);
		controller.student.Score1__c = 1;
		controller.student.Score2__c = 2;
		controller.student.Score3__c = 3;
		controller.classNameInserting = 'Chemistry';


		Test.startTest();
		controller.doInsert();
		Student__c s = [select Namef__c
								,Namel__c
								,Gender__c
								,Birthday__c
								,Score1__c
								,Score2__c
								,Score3__c
								,Class__c
						from Student__c
						where Namef__c = 'vy 6'];
		Class__c c = [select className__c from Class__c where id =: s.Class__c];
		Test.stopTest();

		System.assertEquals(s.Namef__c, 'vy 6');
		System.assertEquals(s.Namel__c, 'truong');
		System.assertEquals(s.Gender__c, false);
		System.assertEquals(s.Birthday__c, Date.newInstance(2010, 9, 4));
		System.assertEquals(s.Score1__c, 1);
		System.assertEquals(s.Score2__c, 2);
		System.assertEquals(s.Score3__c, 3);
		System.assertEquals(c.className__c, 'Chemistry');


	}
	@isTest
	static void testActionDeleteStudentBeSelected()
	{
		Controller controller = new Controller();
		//setup conditions for searching students
		controller.objKeySearch.increasing = true;
		controller.objKeySearch.studentName = new Student__c(Name = 'zzz');
		controller.objKeySearch.className = 'Chemistry';
		controller.objKeySearch.objStudentTo = new Student__c(Birthday__c = Date.newInstance(2000, 1, 1));
		controller.objKeySearch.objStudentFrom = new Student__c(Birthday__c = Date.newInstance(2000, 1, 1));

		Test.startTest();
		controller.actionSearch();
		for(controller.StudentDTO s : controller.objStudentList)
		{
			if(s.student.Namef__c.equals('vy 1'))
			{
				s.isSelected = true;
			}
		}
		controller.actionDeleteStudentBeSelected();
		Student__c queryResult = [select id , IsDeleted from Student__c where Namef__c = 'vy 1' ALL ROWS];
		Test.stopTest();

		System.assertEquals(queryResult.IsDeleted, true);

	}

	private List<controller.StudentDTO> sort(List<controller.StudentDTO> l, Boolean increasing){
		List<controller.StudentDTO> result = new List<controller.StudentDTO>();
		if(increasing){
			while(!l.isEmpty()){
				String max = l.get(0).student.Namef__c;
				controller.StudentDTO maxObj = l.get(0);
				for(controller.StudentDTO o :l){
					if(o.student.Namef__c.compareTo(max) > 0){
						max = o.student.Namef__c;
						maxObj = o;
					}
				}
				result.add(new controller.StudentDTO(maxObj.student));
				l.remove(l.indexOf(maxObj));
			}
		}else{
			while(!l.isEmpty()){
				String min = l.get(0).student.Namef__c;
				controller.StudentDTO minObj = l.get(0);
				for(controller.StudentDTO o :l){
					if(o.student.Namef__c.compareTo(min) < 0){
						min = o.student.Namef__c;
						minObj = o;
					}
				}
				result.add(new controller.StudentDTO(minObj.student));
				l.remove(l.indexOf(minObj));
			}
		}
		return result;
	}
}