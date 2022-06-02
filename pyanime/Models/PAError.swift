//
//  PAError.swift
//  pyanime
//
//  Created by Mohammed Alessi on 18/04/2022.
//

enum PAError: String, Error {
    case invalidUrl = "invalid url"
    case fetchHtml = "something went wrong in fetching html from url"
    case htmlParsing = "somthing went wrong while parsing html to document"
    case extractingData = "somthing went wrong while extracting data from document"
    case unkownError = "somthing went wrong we dont know why, please try again"
}
