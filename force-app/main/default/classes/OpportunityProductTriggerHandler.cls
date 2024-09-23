public class OpportunityProductTriggerHandler extends TriggerHandler {
    private void main(){
        
        List<OpportunityLineItem> oppList = (List<OpportunityLineItem>) Trigger.new;
        List<Id> product2Ids = new List<Id>();
        Map<Id, String> familyToProductId = new Map<Id, String>();
        
        for(OpportunityLineItem oppProd : oppList) {
            if(oppProd.Product2Id != null){
                product2Ids.add(oppProd.Product2Id);
            }
        }
        
        List<Product2> products = [
            SELECT Family
            FROM Product2
            WHERE Id IN :product2Ids
        ];
        
        for(Product2 prod : products) {
            familyToProductId.put(prod.Id, prod.Family);
        }
        
        for(OpportunityLineItem oppProd : oppList) {
            oppProd.Product_Family_Match__c = familyToProductId.get(oppProd.Product2Id);
        }
        
    }
    
    public override void beforeUpdate() {
        main();
    }
    
    public override void beforeInsert() {
        main();    
    }
}