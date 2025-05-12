/**
 * WeatherApiConfig is a utility class that retrieves configuration values from a Custom Metadata Type.
 * It ensures the Weather API endpoint and timeout values are available and valid.
 */
public class WeatherApiConfig {

    /**
     * Loads the configuration record from the Weather_Api_Config__mdt custom metadata.
     * 
     * @return A Weather_Api_Config__mdt record containing API endpoint and timeout settings.
     * @throws CalloutException If required config values are missing.
     */
    public static Weather_Api_Config__mdt getConfig() {
        // Use different metadata for test context
        Weather_Api_Config__mdt config = [
            SELECT Endpoint_URL__c, Timeout__c 
            FROM Weather_Api_Config__mdt
            WHERE MasterLabel = :(
                Test.isRunningTest() ? 'Mock Endpoint' : 'Weather Api Config'
            )
            LIMIT 1
        ];

        if (String.isBlank(config.Endpoint_URL__c)) {
            throw new CalloutException('Weather API endpoint URL is not configured.');
        }

        if (config.Timeout__c == null) {
            throw new CalloutException('Weather API timeout value is missing.');
        }

        return config;
    }
}