public with sharing class EmployeeSyncBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallout {

    public String batchContext;
    public final String BATCH_CONTEXT_GET_S3_FILE = 'getS3File';
    public final String BATCH_CONTEXT_UPDATE_EMPLOYEES = 'updateEmployees';

    public EmployeeSyncBatch(String batchContext) {
        this.batchContext = batchContext;
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        if(batchContext.equalsIgnoreCase(BATCH_CONTEXT_GET_S3_FILE)) {
            String query = 'SELECT Id, EmployeeSyncEnabled__c from App_Config__c LIMIT 1';
        }
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){

        if(batchContext.equalsIgnoreCase(BATCH_CONTEXT_GET_S3_FILE)) {
            // check Employee sync enabled
            if(scope[0].EmployeeSyncEnabled__c) {
                String getFileUrl = 'http://localhost:8080/gets3';
                Http http = new Http();
                HttpRequest httpRequest = new httpRequest();
                httpRequest.setEndpoint(getFileUrl);
                httpRequest.setMethod('GET');
                HttpResponse res = http.send(httpRequest);
            }
        } else if(batchContext.equalsIgnoreCase(BATCH_CONTEXT_UPDATE_EMPLOYEES)) {
            List<Employee__c> employees = (List<Employee__c>) scope;
        }

    }
}
