trigger TransportadoraTrigger on Transportadora__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        TransportadoraTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}