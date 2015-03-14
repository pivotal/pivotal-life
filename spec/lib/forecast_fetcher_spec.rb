require 'spec_helper'
require 'webmock'
include WebMock::API

describe ForecastFetcher do
  let(:api_key) { 'FAKE-API-KEY' }

  let(:forecast_fetcher) { ForecastFetcher.new api_key }

  let(:sf_forecast_url) do
    'https://api.forecast.io/forecast/FAKE-API-KEY/37.781667,-122.404367?units=us'
  end

  let(:pa_forecast_url) do
    'https://api.forecast.io/forecast/FAKE-API-KEY/37.394555,-122.148039?units=us'
  end

  let(:nyc_forecast_url) do
    'https://api.forecast.io/forecast/FAKE-API-KEY/40.740673,-73.994808?units=us'
  end

  let(:london_forecast_url) do
    'https://api.forecast.io/forecast/FAKE-API-KEY/51.5072,0.1275?units=uk'
  end

  let(:toronto_forecast_url) do
    'https://api.forecast.io/forecast/FAKE-API-KEY/43.649932,-79.375756?units=si'
  end

  before do
    stub_request(:get, nyc_forecast_url).to_return(:body => File.read('spec/fixtures/forecast/nyc.json'))
    stub_request(:get, pa_forecast_url).to_return(:body => File.read('spec/fixtures/forecast/palo-alto.json'))
    stub_request(:get, sf_forecast_url).to_return(:body => File.read('spec/fixtures/forecast/sf.json'))
    stub_request(:get, london_forecast_url).to_return(:body => File.read('spec/fixtures/forecast/london.json'))
    stub_request(:get, toronto_forecast_url).to_return(:body => File.read('spec/fixtures/forecast/toronto.json'))
  end

  it 'collects forecast data for each location' do
    expect(forecast_fetcher.data[:sf]).to eq({
      :current_temp=>55,
      :current_icon=>"partly-cloudy-day",
      :current_desc=>"Mostly Cloudy",
      :apparent_temp=>55,
      :later_desc=>"Partly cloudy later this evening.",
      :later_icon=>"partly-cloudy-day",
      :next_desc=>"Mostly cloudy for the hour.",
      :next_icon=>"partly-cloudy-day"
    })
    expect(forecast_fetcher.data[:pa]).to eq({
      :current_temp=>66,
      :current_icon=>"partly-cloudy-day",
      :current_desc=>"Mostly Cloudy",
      :apparent_temp=>66,
      :later_desc=>"Partly cloudy until this evening.",
      :later_icon=>"partly-cloudy-day",
      :next_desc=>"Mostly cloudy for the hour.",
      :next_icon=>"partly-cloudy-day"
    })
    expect(forecast_fetcher.data[:nyc]).to eq({
      :current_temp=>55,
      :current_icon=>"partly-cloudy-day",
      :current_desc=>"Mostly Cloudy",
      :apparent_temp=>55,
      :alternate_temp=>13,
      :later_desc=>"Partly cloudy later this evening.",
      :later_icon=>"partly-cloudy-day",
      :next_desc=>"Mostly cloudy for the hour.",
      :next_icon=>"partly-cloudy-day"
    })
  end
end
