public with sharing class TransportadoraTriggerHandler {
    public static void handleAfterUpdate(List<Transportadora__c> newList, Map<Id, Transportadora__c> oldMap) {
        TransportadoraService.processAfterUpdate(newList, oldMap);
    }
}
