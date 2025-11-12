public with sharing class TransportadoraService {

    public static void processAfterUpdate(List<Transportadora__c> newList, Map<Id, Transportadora__c> oldMap) {
        if (newList == null || newList.isEmpty() || oldMap == null) return;

        List<Transportadora__c> transportadorasDesable = new List<Transportadora__c>();

        for (Transportadora__c newTranspTranspotadora : newList) {
            Transportadora__c oldaTransportadora = oldMap.get(newTranspTranspotadora.Id);

            if (oldaTransportadora != null && oldaTransportadora.Status__c != 'Inativa' && newTranspTranspotadora.Status__c == 'Inativa'){
                transportadorasDesable.add(newTranspTranspotadora);      
            } 
        }

        if (!transportadorasDesable.isEmpty())  enviarNotificacoes(transportadorasDesable);   
    }

    private static void enviarNotificacoes(List<Transportadora__c> transportadoras) {
        String notificationTypeId;
        try {
            notificationTypeId = [
                SELECT Id 
                FROM CustomNotificationType 
                WHERE DeveloperName = 'Transportadora_Notification' 
                LIMIT 1
            ].Id;
        } catch (Exception e) {
            System.debug('Erro ao buscar nonotificação: ' + e.getMessage());
            return;
        }

        for (Transportadora__c t : transportadoras) {
            try {
                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                notification.setTitle('Transportadora Inativada');
                notification.setBody('A transportadora "' + t.Name + '" foi marcada como Inativa.');
                notification.setNotificationTypeId(notificationTypeId);
                notification.setTargetId(t.Id);
                notification.send(new Set<String>{ String.valueOf(t.LastModifiedById) });
            } catch (Exception e) {
                System.debug('Erro ao enviar notificação ' + e.getMessage());
            }
        }
    }

     public static TransportadoraDTO createTransportadora(TransportadoraDTO dto) {
        validateRequiredFields(dto);

        Transportadora__c nova = fromDTO(dto);
        insert nova;

        return toDTO(nova);
    }

    public static TransportadoraDTO getTransportadora(Id transportadoraId) {
        Transportadora__c t = TransportadoraSelector.getById(transportadoraId);
        return toDTO(t);
    }

    public static TransportadoraDTO updateTransportadora(Id transportadoraId, TransportadoraDTO dto) {
        validateRequiredFields(dto);

        Transportadora__c existente = TransportadoraSelector.getById(transportadoraId);
        if (existente == null) throw new IllegalArgumentException('Transportadora não encontrada.');

        existente.Name = dto.nome;
        existente.CNPJ__c = dto.cnpj;
        existente.Email__c = dto.email;
        existente.Endereco__c = dto.endereco;
        existente.Telefone__c = dto.telefone;
        existente.Status__c = dto.status;

        update existente;
        return toDTO(existente);
    }

    public static void deleteTransportadora(Id transportadoraId) {
        Transportadora__c t = TransportadoraSelector.getById(transportadoraId);
        if (t != null) delete t;
    }

    private static Transportadora__c fromDTO(TransportadoraDTO dto) {
        Transportadora__c t = new Transportadora__c();
        t.Name = dto.nome;
        t.CNPJ__c = dto.cnpj;
        t.Email__c = dto.email;
        t.Endereco__c = dto.endereco;
        t.Telefone__c = dto.telefone;
        t.Status__c = dto.status;
        return t;
    }

    private static TransportadoraDTO toDTO(Transportadora__c t) {
        if (t == null) return null;
        TransportadoraDTO dto = new TransportadoraDTO();
        dto.id = t.Id;
        dto.nome = t.Name;
        dto.cnpj = t.CNPJ__c;
        dto.email = t.Email__c;
        dto.endereco = t.Endereco__c;
        dto.telefone = t.Telefone__c;
        dto.status = t.Status__c;
        return dto;
    }

    private static void validateRequiredFields(TransportadoraDTO dto) {
        if (String.isBlank(dto.nome) || String.isBlank(dto.cnpj)) {
            throw new IllegalArgumentException('Os campos "Nome" e "CNPJ" são obrigatórios.');
        }
    }
}