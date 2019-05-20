global class ImportDataScheduleBatch implements Schedulable {
	DateTime runtime = null;
	global void execute(SchedulableContext context) {
		try {
			ImportDataPatch importDataBatch = new ImportDataPatch();
			Database.executeBatch(importDataBatch);

			DateTime runtime = (runtime!=null) ? runtime : System.now().addMinutes(60);
        	if ( runtime >= System.now() ) {
        	    DateTime next = runtime;
        	    String cron = next.second() + ' ' + next.minute() + '* * *';
	
        	    Id jobId = System.schedule('ImportDataPatch', cron, new ImportDataScheduleBatch());
        	}
		} catch(Exception ex) {
			System.debug(ex.getMessage());
		}
	}
}