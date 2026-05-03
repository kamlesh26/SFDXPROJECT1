/**
 * Class Name    : TicketSystem
 * Description   : Handles ticket creation by integrating Salesforce with Freshdesk API.
 * Author        : Kamlesh Verma
 * Created Date  : 03 May 2026
 *
 * Method        : createTicket
 * Description   : Creates a support ticket in Freshdesk using REST API callout.
 *
 * Parameters    :
 *   - sub        (String)  : Subject of the ticket
 *   - email      (String)  : Requester email address
 *   - description(String)  : Detailed description of the issue
 *   - priorty    (Integer) : Priority of the ticket (e.g., 1-Low, 2-Medium, 3-High, 4-Urgent)
 *   - status     (Integer) : Status of the ticket (e.g., 2-Open, 3-Pending, etc.)
 *
 * Returns       :
 *   - String : Ticket ID if successfully created, otherwise empty string
 *
 * Notes         :
 *   - Requires Remote Site Setting or Named Credential (freshDesk)
 *   - Uses HTTP POST callout with JSON body
 *   - Handles basic error scenarios and unauthorized endpoint issues
 *
 * Modification Log:
 * -----------------------------------------------------------
 * Version   Date         Author          Description
 * 1.0       03-05-2026   Kamlesh Verma   Initial Version
 */
public class TicketSystem {
      
     public static String createTicket(String sub, String email, String description, Integer priorty, Integer status){

        String errorMessage = '';
	    String requestBody  = '{'+
                                '"description": "'+description+'",'+
                                '"subject": "'+sub+'",'+
                                '"email": "'+email+'",'+
                                '"priority": '+priorty+','+
                                '"status": '+status+
                            '}';
        System.debug(' requestBody '+requestBody);
        Http http = new Http();
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setEndpoint('callout:freshDesk');
        //httpReq.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(cred)));
        httpReq.setBody(requestBody);
        HttpResponse response = new HttpResponse();
        
        try{
             response = http.send(httpReq);
            if( response.getStatusCode() == 201 ){
                String responseBody = response.getBody();
              
 //parse the response Body and get the id of the ticket
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);   
                return String.valueOf(result.get('id'));



               
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add  Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
        } 

        return '';
    }
    
}