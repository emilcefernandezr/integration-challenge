@IsTest
private class WeatherServiceTest {

    @IsTest
    static void testGetWeatherData_Current() {
        Test.setMock(HttpCalloutMock.class, new WeatherApiMock());

        Test.startTest();
        String result = WeatherService.getWeatherData('Tokyo', false);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Expected a non-null response');
        System.assert(result.contains('Rainy'), 'Expected "Rainy" in the response');
    }

    @IsTest
    static void testGetWeatherData_Forecast() {
        Test.setMock(HttpCalloutMock.class, new WeatherApiMock());

        Test.startTest();
        String result = WeatherService.getWeatherData('Tokyo', true);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Expected a non-null response');
        System.assert(result.contains('Sunny'), 'Expected "Sunny" in forecast response');
    }

    @IsTest
    static void testMissingCity_ThrowsHandledException() {
        Test.setMock(HttpCalloutMock.class, new WeatherApiMock());

        Test.startTest();
        try {
            WeatherService.getWeatherData('', false);
        } catch (AuraHandledException e) {
            System.assertEquals('Script-thrown exception', e.getMessage(), 'Unexpected exception message');
        }
        Test.stopTest();
    }

    @IsTest
    static void testInvalidEndpoint_ErrorResponse() {
        Test.setMock(HttpCalloutMock.class, new WeatherApiMock());
        Test.startTest();
        try {
            WeatherService.getWeatherData('UnknownCity', false);
        } catch (AuraHandledException e) {
            System.assertEquals('Script-thrown exception', e.getMessage(), 'Expected error message for bad callout');
        }
        Test.stopTest();
    }
}