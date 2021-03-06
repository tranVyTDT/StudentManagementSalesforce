public with sharing class TriggerHandle 
{
	public TriggerHandle () {}

	public void onBeforeInsert (List<Student__c> newStudentList)
	{
		try
		{
			for(Student__c s : newStudentList)
			{
				//error if user have not fill score or birthday
				if(s.Score1__c == -1)
				{
					s.Score1__c.addError('please enter chemistry score');
				}
				else if(s.Score2__c == -1)
				{
					s.Score2__c.addError('please enter physic score');
				}
				else if(s.Score3__c == -1)
				{
					s.Score3__c.addError('please enter math score');
				}
				else if(s.BirthDay__c == null)
				{
					s.BirthDay__c.addError('please choose a birthday');
				}
				else
				{
					// errer if age greater than 18 or less than 6  
					Integer age = Date.today().daysBetween(s.BirthDay__c) / 365;
					if(age < -18 || age > -6)
					{
						s.BirthDay__c.addError('invalid birthday');
					}
				}
			}
		}
		catch(Exception ex )
		{
			throw new CustomException(ex.getMessage());
		}	
	}
	public void onAfterInsert(List<Student__c> newStudentList)
	{
		Savepoint sp;
		try
		{
			System.debug(newStudentList);
			sp = Database.setSavepoint();
			this.executeNOStudentsUpdate(newStudentList , 'insert');
			this.executeNOFAPStudentsUpdate(newStudentList , 'insert');
			
		}
		catch(Exception ex)
		{
			if (sp != null) {
				Database.rollback(sp);
			}
			throw new CustomException(ex.getMessage());
		}
	}
	public void onAfterDelete(List<Student__c> oldStudentList)
	{
		try
		{
			System.debug('delete run');
			this.executeNOStudentsUpdate(oldStudentList, 'delete');
			this.executeNOFAPStudentsUpdate(oldStudentList, 'delete');

		}
		catch(Exception ex)
		{	
			throw new CustomException(ex.getMessage());
		}
	}
	public void onAfterUpdate(List<Student__c> newStudentList, List<Student__c> oldStudentList )
	{
		Map<Id,String> differentStudenMap = new Map<Id,String>();
		// find the student change classes to update new and old classes
		for(Student__c newS : newStudentList)
		{
			for(Student__c oldS : oldStudentList)
			{
				if(!newS.State__c.equalsIgnoreCase(oldS.State__c))
				{
					differentStudenMap.put(newS.Class__c , newS.State__c);
				}
			}

		}
		// select all classes to compare with students be selected
		List<Class__c> classList = [SELECT id 
									, NumberOfFailedStudents__c
									, NumberOfPassedStudents__c
									FROM Class__c];
		List<Class__c> classListUpdate = new List<Class__c>();
		for(Class__c c : classList)
		{
			if(differentStudenMap.containsKey(c.id)){
				// update number of passed and falied in class
				//student changed from falied to passed
				if(differentStudenMap.get(c.id).equalsIgnoreCase('passed'))
				{
					c.NumberOfPassedStudents__c += 1;
					c.NumberOfFailedStudents__c -= 1;
					classListUpdate.add( c);
				}
				//student changed from passed to failed
				else
				{
					c.NumberOfPassedStudents__c -= 1;
					c.NumberOfFailedStudents__c += 1;
					classListUpdate.add( c);
				}
			}
		}
		update classListUpdate;
	}
	// update number of students failed and passed in object class__c
	private void executeNOFAPStudentsUpdate(list<Student__c> studentList, String action)
	{
		Map<ID, Integer> classIDMapWithPassedStudents = new Map<ID, Integer>();
		Map<ID, Integer> classIDMapWithFaliedStudents = new Map<ID, Integer>();
		// select all classes to 2 maps , failed and passed students
		// put class id with value into map , value is number of appearences of classes id in student list 
		for(Student__c s : studentList)
		{
			//execute with passed students
			if(s.State__c.equalsIgnoreCase('passed'))
			{
				if(classIDMapWithPassedStudents.containsKey(s.Class__c))
				{
					classIDMapWithPassedStudents.put(s.Class__c, classIDMapWithPassedStudents.get(s.Class__c) + 1);
				}
				else
				{
					classIDMapWithPassedStudents.put(s.Class__c, 1);
				}
			}
			//execute with failed students
			else
			{
				if(classIDMapWithFaliedStudents.containsKey(s.Class__c))
				{
					classIDMapWithFaliedStudents.put(s.Class__c, classIDMapWithFaliedStudents.get(s.Class__c) + 1);
				}
				else
				{
					classIDMapWithFaliedStudents.put(s.Class__c, 1);
				}
			}
		}
		List<Class__c> classList = [SELECT id, NumberOfFailedStudents__c, NumberOfPassedStudents__c From Class__c];
		//execute update number of passed and failed students
		List<Class__c> classListUpdate = new List<Class__c>();
		for(Class__c c : classList) 
		{
			// execute update number failed students
			if(classIDMapWithFaliedStudents.containsKey(c.id))
			{	
				//action is insert
				if(action.equalsIgnoreCase('insert'))
				{
					c.NumberOfFailedStudents__c += classIDMapWithFaliedStudents.get(c.id);
				}
				//action is delete
				else
				{
					c.NumberOfFailedStudents__c -= classIDMapWithFaliedStudents.get(c.id);
				}
				classListUpdate.add(c);
				classIDMapWithFaliedStudents.remove(c.id);
			}
			// execute update number of passed students
			if(classIDMapWithPassedStudents.containsKey(c.id))
			{
				// action is insert
				if(action.equalsIgnoreCase('insert'))
				{
					c.NumberOfPassedStudents__c += classIDMapWithPassedStudents.get(c.id);
				}
				// action is delete
				else
				{
					c.NumberOfPassedStudents__c -= classIDMapWithPassedStudents.get(c.id) ;
				}
				classListUpdate.add(c); 
				classIDMapWithPassedStudents.remove(c.id);
			}
		}
		update classListUpdate;

	}
	// update number of students in object class__c
	private void executeNOStudentsUpdate(List<Student__c> studentList, String action)
	{

		Map<ID, Integer> classIDMap = new Map<ID, Integer>();
		// select all classes in the student list
		// put class id with value into map , value is number of appearences of classes id in student list 
		for(Student__c s : studentList)
		{
			if(classIDMap.containsKey(s.Class__c))
			{
				classIDMap.put(s.Class__c, classIDMap.get(s.Class__c) + 1);
			}
			else
			{
				classIDMap.put(s.Class__c, 1);
			}
		}
		List<Class__c> classList = [SELECT id, NumberOfStudents__c From Class__c];
		System.debug(classList.get(0).NumberOfStudents__c);
		// execute updating number of students in classes
		List<Class__c> classListUpdate = new List<Class__c>();
		for(Class__c c : classList)
		{
			if(classIDMap.containsKey(c.id))
			{
				// action is insert
				if(action.equals('insert')){
					System.debug('insert succed');
					c.NumberOfStudents__c = classIDMap.get(c.id) + c.NumberOfStudents__c;
				}
				//action is delete
				else
				{
					System.debug('delete succed');
					c.NumberOfStudents__c = c.NumberOfStudents__c - classIDMap.get(c.id);
				}
				
				classListUpdate.add(c);
				// revome key with the specified class updated
				classIDMap.remove(c.id);
			}
		}
		update classListUpdate;  
	}
	public class CustomException extends Exception {}
}