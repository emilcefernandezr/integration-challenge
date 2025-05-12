/**
 * WeatherApiClient encapsulates the logic to perform HTTP callouts to the external Weather API.
 * It builds the request URL, sets headers if needed, sends the request, and processes the response.
 */
public with sharing class WeatherApiClient {

    /**
     * Makes an HTTP GET request to the Weather API for the given city and data type (current/forecast).
     * 
     * @param city            The name of the city.
     * @param includeForecast If true, fetches forecast data; else, fetches current weather data.
     * @return A JSON string returned by the external API.
     * @throws CalloutException If the API responds with an error or request fails.
     */
    public static String fetchWeatherData(String city, Boolean includeForecast) {
        if (String.isBlank(city)) {
            throw new CalloutException('City name cannot be empty.');
        }
        
        Weather_Api_Config__mdt config = WeatherApiConfig.getConfig();
        
        String baseUrl = config.Endpoint_URL__c;
        String endpointPath = includeForecast ? '/services/apexrest/WeatherService/forecast/' : '/services/apexrest/WeatherService/current/';
        String fullUrl = baseUrl + endpointPath + EncodingUtil.urlEncode(city, 'UTF-8');

        HttpRequest request = new HttpRequest();
        request.setEndpoint(fullUrl);
        request.setMethod('GET');
        request.setTimeout(config.Timeout__c.intValue());

        Http http = new Http();
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return response.getBody();
        } else {
            throw new CalloutException(
                'API responded with status: ' + response.getStatusCode() +
                ', message: ' + response.getStatus() +
                ', body: ' + response.getBody()
            );
        }
    }
}