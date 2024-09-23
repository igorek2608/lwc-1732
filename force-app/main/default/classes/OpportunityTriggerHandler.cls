public class OpportunityTriggerHandler extends TriggerHandler {
    List<Opportunity> oppList = (List<Opportunity>) Trigger.new;
    List<Opportunity> oldOppList = (List<Opportunity>) Trigger.old;

    final static String DIY_GROUP = '0125j000000aNaNAAU';
    final static String CUMPUS_GROUP = '0125j000000aNaSAAU';

    public void setRecordType(){
        for(Opportunity opp : oppList){
            if(opp.Number_of_Students__c > 50){
                opp.RecordTypeId = CUMPUS_GROUP;
                System.debug('SystemDebugLOG => CUMPUS_GROUP');

            } else {
                opp.RecordTypeId = DIY_GROUP;
                System.debug('SystemDebugLOG => DIY_GROUP');

            }
        }
    }

    public void changeAccountInterest() {
        List<Account_Interest__c> accInterestList = new List<Account_Interest__c>();
        List<Account_Interest__c> delAccInterest = new List<Account_Interest__c>();

        List<OpportunityLineItem> oppProductList = [
            SELECT FIELDS(STANDARD)
            FROM OpportunityLineItem
            WHERE OpportunityId IN: oppList
        ];

        List<Id> product2Ids = new List<Id>();
        Map<Id, String> nameToProductId = new Map<Id, String>();

         for (OpportunityLineItem oppProd : oppProductList) {
            if (oppProd.Product2Id != null) {
                product2Ids.add(oppProd.Product2Id);
            }
        }

        List<Product2> products = [
            SELECT Name
            FROM Product2
            WHERE Id IN : product2Ids
        ];

        for (Product2 prod : products) {
            nameToProductId.put(prod.Id, prod.Name);
        }

        for (Opportunity opp : oppList) {
            if (opp.IsWon) {
                for (OpportunityLineItem oppProd : oppProductList) {
                    Account_Interest__c accInterest = new Account_Interest__c();
                    accInterest.Name = nameToProductId.get(oppProd.Product2Id);
                    accInterest.Deal_Link__c = opp.Id;
                    accInterest.Number_of_Sets__c = oppProd.Quantity;
                    accInterest.Product__c = oppProd.Product2Id;
                    accInterest.Account__c = opp.AccountId;
                    accInterest.Purchase__c = oppProd.ServiceDate;
                    System.debug('SystemDebugLOG => ' + accInterest);
                    accInterestList.add(accInterest);
                    System.debug('SystemDebugLOG => ' +accInterestList);
                }
            } else {
                if (oldOppList!=null) {
                    Integer index= oppList.indexOf(opp);
                    if (oldOppList[index].IsWon) {
                        delAccInterest = [
                            SELECT Id, Deal_Link__c
                            FROM Account_Interest__c
                            WHERE Deal_Link__c = :opp.Id
                        ];
                    }
                }
            }
        }
        if (accInterestList != null) {
            insert accInterestList;
        }
        if (delAccInterest != null) {
            delete delAccInterest;
        }
    }

    public override void beforeUpdate() {
        changeAccountInterest();
        setRecordType();
    }

    public override void beforeInsert() {
        changeAccountInterest();
        setRecordType();
    }

}