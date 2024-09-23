public class ProductTriggerHandler extends TriggerHandler{
   
    List<Product2> productList = (List<Product2>) Trigger.new;
      
      private void main() {
         
          List<Product_Family_by_Mapping__mdt> metaDateList = Product_Family_by_Mapping__mdt.getAll().values();
          List<String> prodCodeList = new List<String>();
          
          for(Product2 curProd : productList) {
              for(Integer i = 0; i < metaDateList.size(); i++) {
                  Product_Family_by_Mapping__mdt curMet = metaDateList[i];
                  String prodFamily = curMet.Product_Family__c;
                  String prodCode = curMet.Product_Code__c;
                  prodCodeList.add(prodCode);
                  if(curProd.ProductCode == prodCode) {
                      curProd.Family = prodFamily;
                  }
              }
              if(prodCodeList.contains(curProd.ProductCode) == false) {
                  curProd.addError('Such product code is not allowed in the system. Please update the PFC mapping or contact administrator.');
              }
          }
      }
      
      private void updateOppProduct() {
          List<Id> product2Ids = new List<Id>();
          Map<Id, String> familyToProductId = new Map<Id, String>();
          
          for(Product2 prod : productList) {
              
              List<OpportunityLineItem> oppProducts = [
                SELECT Product_Family__c
                FROM OpportunityLineItem
                WHERE Product2Id = :prod.Id
            ];
              
              for(OpportunityLineItem oppProd : oppProducts) {
                    oppProd.Product_Family_Match__c = prod.Family;
              }
          }
      }       
      
      public override void beforeInsert() {
          main();
      }
      
      public override void beforeUpdate() {
          main();
      }
      
      public override void afterInsert() {
          updateOppProduct();
      }
      
      public override void afterUpdate() {
          updateOppProduct();
      }




      /* wdfwdfwdf */
  }