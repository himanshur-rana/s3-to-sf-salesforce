public with sharing class EmployeeSyncBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {

    public String batchContext;
    public final String BATCH_CONTEXT_GET_S3_FILE = 'getS3File';
    public final String BATCH_CONTEXT_UPDATE_EMPLOYEES = 'updateEmployees';

    public EmployeeSyncBatch(String batchContext) {
        this.batchContext = batchContext;
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = '';
        if(batchContext.equalsIgnoreCase(BATCH_CONTEXT_GET_S3_FILE)) {
            query = 'SELECT Id, EmployeeSyncEnabled__c from App_Config__c LIMIT 1';
        } else if(batchContext.equalsIgnoreCase(BATCH_CONTEXT_UPDATE_EMPLOYEES)) {
            query = 'SELECT Id FROM Employee__c';
        }
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){

        if(batchContext.equalsIgnoreCase(BATCH_CONTEXT_GET_S3_FILE)) {
            // check Employee sync enabled
            List<App_Config__c> appConfigList = (List<App_Config__c>) scope;
            App_Config__c appConfigObj = appConfigList[0];
            if(appConfigObj.EmployeeSyncEnabled__c) {
                String getFileUrl = 'http://localhost:8080/gets3';
                Http http = new Http();
                HttpRequest httpRequest = new httpRequest();
                httpRequest.setEndpoint(getFileUrl);
                httpRequest.setMethod('GET');
                HttpResponse res = http.send(httpRequest);
                String responseBody = res.getBody();
                System.debug('Response body ++' + responseBody);
            }
        } else if(batchContext.equalsIgnoreCase(BATCH_CONTEXT_UPDATE_EMPLOYEES)) {
            List<Employee__c> employees = (List<Employee__c>) scope;
        }

    }

    public void finish(Database.BatchableContext BC) {

    }
}
