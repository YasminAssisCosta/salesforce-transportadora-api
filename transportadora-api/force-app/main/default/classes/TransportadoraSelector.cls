public with sharing class TransportadoraSelector {

    public static Transportadora__c getById(Id transportadoraId) {
        return [
            SELECT Id, Name, Status__c, CNPJ__c, Email__c, Endereco__c, Telefone__c
            FROM Transportadora__c
            WHERE Id = :transportadoraId
            LIMIT 1
        ];
    }
}
