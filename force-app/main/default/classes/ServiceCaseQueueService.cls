public inherited sharing class ServiceCaseQueueService {
    @AuraEnabled(cacheable=true)
    public static List<Case> getUserCases() {

        List<Group> queueIdList = [
            SELECT Id 
            FROM Group 
            WHERE Type = 'Queue' 
        ];

        List<Case> userCasesList = [
            SELECT CaseNumber, Owner_Name__c, Origin, Priority, Status, OwnerId
            FROM Case 
            WHERE Status <> 'Closed' AND (OwnerId = :UserInfo.getUserId() OR (OwnerId IN :queueIdList))
            ORDER BY OwnerId, Priority ASC, CreatedDate DESC
            LIMIT 25
        ];
        
        return userCasesList;
    }
}