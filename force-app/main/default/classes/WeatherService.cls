/**
 * WeatherService is the main entry point exposed to Lightning components via @AuraEnabled methods.
 * It delegates the task of fetching weather data to the WeatherApiClient class.
 * 
 * This class handles high-level exception handling and ensures a clean contract with the frontend.
 */
public with sharing class WeatherService {

    /**
     * Retrieves weather data (current or forecast) for a given city.
     * 
     * @param city            The name of the city.
     * @param includeForecast If true, retrieves forecast data; otherwise, retrieves current weather.
     * @return A JSON string representing the weather data.
     * @throws AuraHandledException If a callout or unexpected error occurs.
     */
    @AuraEnabled(cacheable=true)
    public static String getWeatherData(String city, Boolean includeForecast) {
        try {
            return WeatherApiClient.fetchWeatherData(city, includeForecast);
        } catch (CalloutException ce) {
            throw new AuraHandledException('Weather API error: ' + ce.getMessage());
        } catch (Exception e) {
            throw new AuraHandledException('Unexpected error while fetching weather data: ' + e.getMessage());
        }
    }
}