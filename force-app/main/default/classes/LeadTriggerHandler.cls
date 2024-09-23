public class LeadTriggerHandler extends TriggerHandler {

    public enum LeadScoringAttributes {
      Is_Not,
      Between,
      More_Then
    }
  
    public override  void beforeInsert(){
        calculateLeadScoreMtd();
    }

    public override void beforeUpdate(){
        calculateLeadScoreMtd();
    }

    public static void calculateLeadScoreMtd(){
        for(Lead ld : (List<Lead>) Trigger.new){
          System.debug('11');
            Decimal leadScorePoint=0;
            if(String.isNotBlank(ld.Phone)){
             System.debug(ld.Phone);
             leadScorePoint+=
            
             getLeadScroringMetadataRule('Phone', LeadScoringAttributes.Is_Not.Name()).Result__c;
            }
            System.debug('22');
            if(String.isNotBlank(ld.Email)){
              leadScorePoint+=
              getLeadScroringMetadataRule('Email', LeadScoringAttributes.Is_Not.Name()).Result__c;
            }
            if(String.isNotBlank(ld.Title)){
                System.debug(ld.Title);
             leadScorePoint+=
             getLeadScroringMetadataRule('Title', LeadScoringAttributes.Is_Not.Name()).Result__c;
            }
            System.debug(ld.Number_of_Students__c);
            if(ld.Number_of_Students__c>Integer.valueOf(getLeadScroringMetadataRule('Number of Students', LeadScoringAttributes.More_Then.Name()).Value__c)){
            System.debug(ld.Number_of_Students__c);
            leadScorePoint+=
             getLeadScroringMetadataRule('Number of Students', LeadScoringAttributes.More_Then.Name()).Result__c;
            } else if(ld.Number_of_Students__c>0 && ld.Number_of_Students__c<26){
             leadScorePoint+=
             getLeadScroringMetadataRule('Number of Students', LeadScoringAttributes.Between.Name()).Result__c;
            }
            if(ld.Number_of_Sets_Required__c>Integer.valueOf(getLeadScroringMetadataRule('Number of Sets', LeadScoringAttributes.More_Then.Name()).Value__c)){
             leadScorePoint+=
             getLeadScroringMetadataRule('Number of Sets', LeadScoringAttributes.More_Then.Name()).Result__c;
            } else if(ld.Number_of_Sets_Required__c>0 && ld.Number_of_Sets_Required__c<16){
             leadScorePoint+=
             getLeadScroringMetadataRule('Number of Sets', LeadScoringAttributes.Between.Name()).Result__c;
            }
            ld.Lead_Score__c = leadScorePoint;
            System.debug(leadScorePoint);
            System.debug(ld.Lead_Score__c);
        }
    }

   /*  public static Lead_Scoring_Settings__mdt getLeadScroringMetadataRule(String fieldName, String leadScoringAttributesName ){
      List<Lead_Scoring_Settings__mdt> test = new List<Lead_Scoring_Settings__mdt>();
      test = [
        SELECT Result__c, Value__c
        FROM Lead_Scoring_Settings__mdt
        WHERE(Field__c = :fieldName AND Condition__c = :leadScoringAttributesName)
        LIMIT 1
      ];
      return test.get(0);
  } */

  public static Lead_Scoring_Settings__mdt getLeadScroringMetadataRule(String fieldName, String leadScoringAttributesName ){
      return[
          SELECT Result__c, Value__c
          FROM Lead_Scoring_Settings__mdt
          WHERE(Field__c = :fieldName AND Condition__c = :leadScoringAttributesName)
      ];
  }
}