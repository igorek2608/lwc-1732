public without sharing class AccountCasesPdfCtrl {
    public List<Case> getAccountCasesPrevWeek() {
        List<Case> cases = [
            SELECT Account_Name__c, Owner_Name__c, CaseNumber, Status, Priority, Origin, CreatedDate 
            FROM Case
            WHERE CreatedDate != THIS_WEEK
            ORDER BY Account_Value__c DESC
        ];

        return cases;
    }
}