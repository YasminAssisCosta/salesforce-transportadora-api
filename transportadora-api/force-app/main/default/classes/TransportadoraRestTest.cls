@isTest
private class TransportadoraRestTest {
    
    @isTest
    static void testPostTransportadora() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/transportadora/';
        req.httpMethod = 'POST';
        
        TransportadoraDTO dto = new TransportadoraDTO();
        dto.nome = 'Transportadora teste';
        dto.cnpj = '11223344556677';
        dto.status = 'Ativa';
        req.requestBody = Blob.valueOf(JSON.serialize(dto));
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TransportadoraRest.createTransportadora();
        Test.stopTest();
        
        System.assertEquals(201, res.statusCode, 'Deveria retornar erro 201');
    }
    
    @isTest
    static void testGetTransportadora() {
        Transportadora__c transportadora = new Transportadora__c(Name = 'Transportadora Get', CNPJ__c = '22334455667788', Status__c = 'Ativa');
        insert transportadora;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/transportadora/' + transportadora.Id;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TransportadoraRest.getTransportadora();
        Test.stopTest();
        
        System.assertEquals(200, res.statusCode, 'Deveria retornar erro 200');
    }
    
    @isTest
    static void testPutTransportadora() {
        Transportadora__c transportadora = new Transportadora__c(Name = 'Teste tranportadora', CNPJ__c = '68.304.881/0001-78', Status__c = 'Ativa');
        insert transportadora;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/transportadora/' + transportadora.Id;
        req.httpMethod = 'PUT';
        
        TransportadoraDTO dto = new TransportadoraDTO();
        dto.nome = 'TesteTransp';
        dto.cnpj = '68.304.881/0001-78';
        dto.status = 'Inativa';
        req.requestBody = Blob.valueOf(JSON.serialize(dto));
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TransportadoraRest.updateTransportadora();
        Test.stopTest();
        
        System.assertEquals(200, res.statusCode, 'Deveria retornar erro 200');
        TransportadoraDTO resultDTO = (TransportadoraDTO) JSON.deserialize(res.responseBody.toString(), TransportadoraDTO.class);
        System.assertEquals('TesteTransp', resultDTO.nome, 'O nome deveria ter sido atualizado.');
        System.assertEquals('Inativa', resultDTO.status, 'O status deveria ter sido atualizado.');
    }
    
    @isTest
    static void testDeleteTransportadora() {
        Transportadora__c transportadora = new Transportadora__c(Name = 'Transportadora Del', CNPJ__c = '74.168.560/0001-96', Status__c = 'Ativa');
        insert transportadora;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/transportadora/' + transportadora.Id;
        req.httpMethod = 'DELETE';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TransportadoraRest.deleteTransportadora();
        Test.stopTest();
        
        System.assertEquals(200, res.statusCode, 'Deveria retornar erro 200');
    }
    
    @isTest
    static void testPostTransportadora_ValidationException() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/transportadora/';
        req.httpMethod = 'POST';
        
        TransportadoraDTO dto = new TransportadoraDTO();
        dto.nome = '';
        dto.cnpj = '';
        req.requestBody = Blob.valueOf(JSON.serialize(dto));
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TransportadoraRest.createTransportadora();
        Test.stopTest();
        
        System.assertEquals(400, res.statusCode, 'Deveria retornar erro 400');
        Map<String, Object> error = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());
        System.assert(error.get('erro').toString().contains('obrigatórios'), 'A mensagem de erro não corresponde.');
    }
    @isTest
    static void testGetTransportadora_NotFound() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/transportadora/999999999999999AAA';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TransportadoraRest.getTransportadora();
        Test.stopTest();
        
        System.assertEquals(400, res.statusCode, 'Deveria retornar erro 400');
    }
}