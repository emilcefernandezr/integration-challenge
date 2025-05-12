@IsTest
global class WeatherApiMock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        String url = req.getEndpoint();

        if (url.contains('/forecast/')) {
            res.setBody('[{"day":"Monday","description":"Sunny"}]');
        } else if (url.contains('/current/')) {
            res.setBody('{"description":"Rainy"}');
        } else {
            res.setBody('Not Found');
            res.setStatusCode(404);
            return res;
        }

        res.setStatusCode(200);
        res.setHeader('Content-Type', 'application/json');
        return res;
    }
}