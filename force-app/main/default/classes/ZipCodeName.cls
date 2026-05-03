/**
 * Class Name    : ZipCodeName
 * Description   : Provides functionality to retrieve the city name based on a given ZIP code
 *                 using an external REST API (zipcodestack).
 *
 * Author        : Kamlesh Verma
 * Created Date  : 03 May 2026
 *
 * Method        : getCityForZipCode
 * Description   : Invocable method used in Flow/Process Builder to fetch city name
 *                 for a given ZIP code via HTTP callout.
 *
 * Annotations   :
 *   - @InvocableMethod(callout=true)
 *     Allows this method to be invoked from Flow and supports external callouts.
 *
 * Parameters    :
 *   - zipCode (List<Integer>) : List containing ZIP code(s). Only the first value is processed.
 *
 * Returns       :
 *   - List<String> : List containing the city name corresponding to the provided ZIP code.
 *
 * API Details   :
 *   - Endpoint : https://api.zipcodestack.com/v1/search
 *   - Method   : GET
 *   - Headers  : apikey (Required for authentication)
 *
 * Notes         :
 *   - Replace 'YOUR_API_KEY' with a valid API key.
 *   - Ensure Remote Site Settings are configured for the endpoint.
 *   - Currently supports US ZIP codes (country=us).
 *   - Assumes at least one result is returned from API.
 *
 * Limitations   :
 *   - Does not handle multiple ZIP codes in the list.
 *   - Minimal error handling (can be enhanced).
 *
 * Modification Log:
 * -----------------------------------------------------------
 * Version   Date         Author          Description
 * 1.0       03-05-2026   Kamlesh Verma   Initial Version
 */
public class ZipCodeName {

    
    @InvocableMethod(callout=true  
                     description='This Action Find the Name of the City based on the Zipcode given to it, for example when the user ask find the name of the City whose zip code is 90210 then it returns the city name')
    public static List<String> getCityForZipCode(List<Integer> zipCode){
        Integer zipCodeToFind = zipCode[0];
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.zipcodestack.com/v1/search?codes=' + zipCodeToFind +'&country=us' );
        req.setMethod('GET');
        req.setHeader('apikey', 'YOUR_API_KEY');
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        Map<String, Object> resultMap = (Map<String, Object>)responseMap.get('results');
        List<Object> zipData = (List<Object>) resultMap.get(String.valueOf(zipCodeToFind));
        Map<String, Object> finalZipResult = (Map<String, Object>)zipData[0];
        
        String cityName = (String)finalZipResult.get('city');
        return new List<String> { cityName };
    }
}