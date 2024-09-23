public with sharing class CaseTriggerHandler extends TriggerHandler {
    public override void afterInsert() {
        CaseFunctions.PublishEventCaseChanged(Trigger.new, 'Insert');
    }

    public override void afterUpdate() {
        CaseFunctions.PublishEventCaseChanged(Trigger.new, 'Update');
    }

    public override void afterDelete() {
        CaseFunctions.PublishEventCaseChanged(Trigger.old, 'Delete');
    }
}