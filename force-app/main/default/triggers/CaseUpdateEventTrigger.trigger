trigger CaseUpdateEventTrigger on Case_Changed__e (after insert) {
    for(Case_Changed__e event: Trigger.new) {
        System.debug('``````````````````' + event.CaseId__c + '````````' + event.CaseStatus__c);
    }
}