//
//  WeatherModel.swift
//  WeatherDemo
//
//  Created by Ahmed Hamam on 24/01/2023.
//

import Foundation

struct WeatherError: Decodable {

    let cod: String
    let message: String

}

struct MyResult: Decodable {

    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?

}
struct Coord: Decodable {

    let lon: Double?
    let lat: Double?

}
struct Weather: Decodable {

    let id: Int?
    let main: String?
    let description: String?
    let icon: String?

}
struct Main: Decodable {

    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?

}
struct Wind: Decodable {

    let speed: Double?
    let deg: Int?

}
struct Clouds: Decodable {

    let all: Int?

}
struct Sys: Decodable {

    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?

}
