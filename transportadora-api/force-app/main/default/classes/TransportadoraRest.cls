@RestResource(urlMapping='/transportadora/*')
global with sharing class TransportadoraRest {

    @HttpGet
    global static void getTransportadora() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            String recordId = req.requestURI.substringAfter('/transportadora/').trim();
            if (String.isBlank(recordId)) {
                throw new IllegalArgumentException('Id da transportadora não informado.');
            }

            TransportadoraDTO dto = TransportadoraService.getTransportadora(recordId);
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(dto));

        } catch (Exception e) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(
                new Map<String, String>{ 'erro' => e.getMessage() }
            ));
        }
    }

    @HttpPost
    global static void createTransportadora() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Savepoint sp = Database.setSavepoint();

        try {
            TransportadoraDTO dto = (TransportadoraDTO) JSON.deserialize(
                req.requestBody.toString(), TransportadoraDTO.class
            );
            TransportadoraDTO criada = TransportadoraService.createTransportadora(dto);

            res.statusCode = 201;
            res.responseBody = Blob.valueOf(JSON.serialize(criada));

        } catch (Exception e) {
            Database.rollback(sp);
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(
                new Map<String, String>{ 'erro' => e.getMessage() }
            ));
        }
    }

    @HttpPut
    global static void updateTransportadora() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Savepoint sp = Database.setSavepoint();

        try {
            String recordId = req.requestURI.substringAfter('/transportadora/').trim();
            if (String.isBlank(recordId)) {
                throw new IllegalArgumentException('Id da transportadora não informado.');
            }

            TransportadoraDTO dto = (TransportadoraDTO) JSON.deserialize(
                req.requestBody.toString(), TransportadoraDTO.class
            );
            TransportadoraDTO atualizada = TransportadoraService.updateTransportadora(recordId, dto);

            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(atualizada));

        } catch (Exception e) {
            Database.rollback(sp);
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(
                new Map<String, String>{ 'erro' => e.getMessage() }
            ));
        }
    }

    @HttpDelete
    global static void deleteTransportadora() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Savepoint sp = Database.setSavepoint();

        try {
            String recordId = req.requestURI.substringAfter('/transportadora/').trim();
            if (String.isBlank(recordId)) {
                throw new IllegalArgumentException('Id da transportadora não informado.');
            }

            TransportadoraService.deleteTransportadora(recordId);

            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(
                new Map<String, String>{ 'mensagem' => 'Transportadora excluída com sucesso.' }
            ));

        } catch (Exception e) {
            Database.rollback(sp);
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(
                new Map<String, String>{ 'erro' => e.getMessage() }
            ));
        }
    }
}
