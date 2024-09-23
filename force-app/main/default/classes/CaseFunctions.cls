public with sharing class CaseFunctions {

    public static void PublishEventCaseChanged (List<Case> incomingList, String action) {
        List<Case_Changed__e> publishEvents = new List<Case_Changed__e>();
        List<Case_Avalible_Event__e> publishAvailbleEvent = new List<Case_Avalible_Event__e>();
       
        for (Case cs : incomingList) {
            Case_Changed__e newEvent = new Case_Changed__e();
            newEvent.CaseId__c = cs.Id;
            newEvent.Action__c = action;
            newEvent.CaseNumber__c = cs.CaseNumber;
            newEvent.CaseStatus__c = cs.Status;
            newEvent.Message__c = 'Case Number' + cs.CaseNumber;
            publishEvents.add(newEvent);
        }
        for (Case cs : incomingList) {
            Case_Avalible_Event__e availbleEvent = new Case_Avalible_Event__e();
            if(string.valueOf(cs.OwnerId).startsWith('0055')) {
                availbleEvent.Case_Id__c = cs.Id;
                availbleEvent.Action__c = action;
                availbleEvent.Case_Number__c = cs.CaseNumber;
                publishAvailbleEvent.add(availbleEvent);
            }
            
        }

        if (!publishEvents.isEmpty()) {
            List<Database.SaveResult> results = EventBus.publish(publishEvents);
            for (Database.SaveResult sr : results) {
                if (sr.isSuccess()) {
                    System.debug('Successfully published event.');
                } else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Error returned: ' +
                                    err.getStatusCode() +
                                    ' - ' +
                                    err.getMessage());
                    }
                }
            }
        }

        if (!publishAvailbleEvent.isEmpty() && action!= 'Delete' ) {
            List<Database.SaveResult> results = EventBus.publish(publishAvailbleEvent);
            for (Database.SaveResult sr : results) {
                if (sr.isSuccess()) {
                    System.debug(publishAvailbleEvent);
                    System.debug('Successfully published avaible event.');
                } else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Error returned: ' +
                                    err.getStatusCode() +
                                    ' - ' +
                                    err.getMessage());
                    }
                }
            }
        } 
    }
}