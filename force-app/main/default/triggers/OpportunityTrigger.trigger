trigger OpportunityTrigger on Opportunity (after insert, after update, before insert, before update) {
    new OpportunityTriggerHandler().run();
}