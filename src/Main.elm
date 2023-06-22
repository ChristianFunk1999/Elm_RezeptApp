module Main exposing (main)

import Browser
import Html exposing (div, text, button, input)
import String exposing (fromInt)
import Html.Events exposing (onClick, onInput)
import Debug exposing (log)
import Navigation

add a b = a + b

type Message = 
    Add
    | TextChanged String

init = 
    { 
        value = 77,
        firstname = "Chris",
        lastname = "Funk",
        name = "RezeptAPP"
    }

view model = 
    div [] [
        text (fromInt model.value),
        text (model.name),
        div [] [],
        input [onInput TextChanged] [],
        button [onClick Add] [text "Add"]
    ]

update msg model = 
    let
        _ = log "lastname" model.lastname
        _ = log "firstname" model.firstname
    in
    case msg of
        Add ->
           {model | firstname = "Peter", value=78}
        TextChanged newText ->
            let
                _ = log "entered Text" newText
            in
            model


main = 
    Browser.sandbox
        {
            init = init,
            view = view,
            update = update
        }