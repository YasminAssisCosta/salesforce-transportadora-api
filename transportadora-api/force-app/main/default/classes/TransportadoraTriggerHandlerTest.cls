@isTest
private class TransportadoraTriggerHandlerTest {

    @isTest
    static void testHandleAfterUpdate_StatusChangeToInativa() {
        Transportadora__c transportadora = new Transportadora__c(
            Name = 'Transportadora Teste',
            CNPJ__c = '69.668.641/0001-15',
            Email__c = 'teste@teste.com',
            Endereco__c = 'Rua Teste, 123',
            Telefone__c = '11999999999',
            Status__c = 'Ativa'
        );
        insert transportadora;

        Test.startTest();

        transportadora.Status__c = 'Inativa';
        update transportadora;

        Test.stopTest();

        Transportadora__c result = [SELECT Status__c FROM Transportadora__c WHERE Id = :transportadora.Id];
        System.assertEquals('Inativa', result.Status__c, 'O status da transportadora deveria ser Inativa.');
    }

    @isTest
    static void testHandleAfterUpdate_StatusChangeNoAction() {
        Transportadora__c transportadora = new Transportadora__c(
            Name = 'Transportadora Teste 2',
            CNPJ__c = '43210987654321',
            Email__c = 'teste2@teste.com',
            Endereco__c = 'Rua Teste, 321',
            Telefone__c = '11888888888',
            Status__c = 'Ativa'
        );
        insert transportadora;

        Test.startTest();

        transportadora.Name = 'Transportadora Teste 2 - Updated';
        update transportadora;

        Test.stopTest();

        Transportadora__c result = [SELECT Name, Status__c FROM Transportadora__c WHERE Id = :transportadora.Id];
        System.assertEquals('Ativa', result.Status__c, 'O status da transportadora não deveria ter sido alterado.');
        System.assertEquals('Transportadora Teste 2 - Updated', result.Name, 'O nome da transportadora deveria ter sido alterado.');
    }
}
