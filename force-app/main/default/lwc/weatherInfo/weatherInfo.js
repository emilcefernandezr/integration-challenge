import { LightningElement, track } from 'lwc';
import getWeatherData from '@salesforce/apex/WeatherService.getWeatherData';
import sunnyImg from '@salesforce/resourceUrl/sunny';
import partlyCloudyImg from '@salesforce/resourceUrl/partly_cloudy';
import rainyImg from '@salesforce/resourceUrl/rainy';
import thunderstormsImg from '@salesforce/resourceUrl/thunderstorms';
import snowyImg from '@salesforce/resourceUrl/snowy';
import sunnyIcon from '@salesforce/resourceUrl/sunny_icon';
import partlyCloudyIcon from '@salesforce/resourceUrl/partly_cloudy_icon';
import rainyIcon from '@salesforce/resourceUrl/rainy_icon';
import thunderstormsIcon from '@salesforce/resourceUrl/thunderstorms_icon';
import snowyIcon from '@salesforce/resourceUrl/snowy_icon';

export default class WeatherInfo extends LightningElement {
    city = '';
    weatherData;
    forecastData;
    error;
    isLoading = false;
    includeForecast = true;
    weatherImage;

    cityOptions = [
        { label: 'Alaska', value: 'Alaska' },
        { label: 'Austin', value: 'Austin' },
        { label: 'Asuncion', value: 'Asuncion' },
        { label: 'Hawaii', value: 'Hawaii' },
        { label: 'London', value: 'London' },
        { label: 'Los Angeles', value: 'LosAngeles' },
        { label: 'Montevideo', value: 'Montevideo' },
        { label: 'New Orleans', value: 'NewOrleans' },
        { label: 'New York', value: 'NewYork' },
        { label: 'Paris', value: 'Paris' },
        { label: 'San Diego', value: 'SanDiego' },
        { label: 'San Francisco', value: 'SanFrancisco' },
        { label: 'Tokyo', value: 'Tokyo' },
        { label: 'Toronto', value: 'Toronto' },
        { label: 'Vancouver', value: 'Vancouver' }
    ];

    handleCityChange(event) {
        this.city = event.detail.value;
    }

    handleToggle(event) {
        this.includeForecast = event.target.checked;
    }

    fetchWeather() {
        this.resetState();

        if (!this.city.trim()) {
            this.error = 'Please enter a city name.';
            return;
        }

        this.isLoading = true;

        getWeatherData({ city: this.city, includeForecast: this.includeForecast })
            .then(result => {
                const parsed = JSON.parse(result);
                if (this.includeForecast) {
                    // this.forecastData = parsed;
                    this.forecastData = parsed.map(item => ({
                        ...item,
                        icon: this.getIconName(item.description)
                    }));
                    this.setWeatherImage(this.forecastData[0].description);
                    
                } else {
                    this.weatherData = parsed;
                    this.setWeatherImage(this.weatherData.description);
                }
            })
            .catch(error => {
                this.error = error?.body?.message || error?.message || 'Unknown error occurred.';
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    resetState() {
        this.error = undefined;
        this.weatherData = undefined;
        this.forecastData = undefined;
        this.weatherImage = undefined;
    }

    setWeatherImage(description) {
        switch (description) {
            case 'Sunny':
                this.weatherImage = sunnyImg;
                break;
            case 'Partly Cloudy':
                this.weatherImage = partlyCloudyImg;
                break;
            case 'Rainy':
                this.weatherImage = rainyImg;
                break;
            case 'Thunderstorms':
                this.weatherImage = thunderstormsImg;
                break;
            case 'Snowy':
                this.weatherImage = snowyImg;
                break;
        }
    }

    getIconName(description) {
        switch (description) {
            case 'Sunny':
                return sunnyIcon;
                break;
            case 'Partly Cloudy':
                return partlyCloudyIcon;
                break;
            case 'Rainy':
                return rainyIcon;
                break;
            case 'Thunderstorms':
                return thunderstormsIcon;
                break;
            case 'Snowy':
                return snowyIcon;
                break;
        }
    }
}