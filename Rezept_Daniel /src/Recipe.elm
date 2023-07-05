module Recipe exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main =
    Browser.sandbox { init = init, update = update, view = view }


-- Model


type alias Model =
    { ingredients : String
    , steps : String
    , prepTime : String
    , difficulty : String
    , categories : String
    , preparationSteps : Int
    , savedRecipe : Maybe String
    }


init : Model
init =
    { ingredients = ""
    , steps = ""
    , prepTime = ""
    , difficulty = "leicht"
    , categories = ""
    , preparationSteps = 1
    , savedRecipe = Nothing
    }


-- Msg


type Msg
    = IngredientsChanged String
    | StepsChanged String
    | PrepTimeChanged String
    | DifficultyChanged String
    | CategoriesChanged String
    | SaveRecipe
    | PreparationStepsChanged String


update : Msg -> Model -> Model
update msg model =
    case msg of
        IngredientsChanged newIngredients ->
            { model | ingredients = newIngredients }

        StepsChanged newSteps ->
            { model | steps = newSteps }

        PrepTimeChanged newPrepTime ->
            { model | prepTime = newPrepTime }

        DifficultyChanged newDifficulty ->
            { model | difficulty = newDifficulty }

        CategoriesChanged newCategories ->
            { model | categories = newCategories }

        PreparationStepsChanged newPreparationSteps ->
            { model | preparationSteps = String.toInt newPreparationSteps |> Maybe.withDefault 1 }

        SaveRecipe ->
            let
                recipe =
                    "Zutaten: " ++ model.ingredients ++ "\n" ++
                    "Zubereitungsschritte: " ++ model.steps ++ "\n" ++
                    "Zubereitungszeit: " ++ model.prepTime ++ "\n" ++
                    "Schwierigkeitsgrad: " ++ model.difficulty ++ "\n" ++
                    "Kategorien: " ++ model.categories

                updatedModel =
                    { model | savedRecipe = Just recipe }
            in
            saveRecipeToLocalStorage updatedModel


saveRecipeToLocalStorage : Model -> Model
saveRecipeToLocalStorage model =
    let
        recipeKey = "savedRecipe"
        updatedLocalStorage =
            Browser.Dom.Storage.getItem recipeKey
                |> Maybe.andThen (\_ -> Browser.Dom.Storage.setItem recipeKey (Just (Maybe.withDefault "" model.savedRecipe)))
    in
    case updatedLocalStorage of
        Just _ ->
            model

        Nothing ->
            { model | savedRecipe = Nothing }


-- View


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ header [ class "header" ]
            [ h1 [ class "title" ] [ text "Das ist deine RezeptApp!" ]
            , Html.blockquote [ class "quote" ]
                [ text "Kochen ist die Kunst, Zutaten zu Rezepten zu kombinieren und dabei einzigartige Geschmackserlebnisse zu erschaffen." ]
            ]
        , div [ class "header-links" ]
            [ a [ class "link", href "Einkaufslisten.html" ] [ text "Einkaufslisten" ]
            , a [ class "link", href "Lieblingsrezepte.html" ] [ text "Lieblingsrezepte" ]
            ]
        , div [ class "image-container" ]
            [ img [ class "image", src "./Bilder/kochloeffel.jpg", alt "ingredients" ] []
            ]
        , br [] []
        , div [ class "form-container" ]
            [ text "Füge hier gleich neue Rezepte hinzu:" 
            , Html.form [ class "form", action "http://dein-server.de/speichern", method "post" ]
                [ label [ class "input-label" ] [ text "Zutaten:" ]
                , br [] []
                , textarea [ class "input", id "ingredients", name "ingredients", onInput IngredientsChanged ] []
                , br [] []
                , label [ class "input-label" ] [ text "Zubereitungsschritte:" ]
                , br [] []
                , textarea [ class "input", id "steps", name "steps", onInput StepsChanged ] []
                , br [] []
                , label [ class "input-label" ] [ text "Zubereitungszeit:" ]
                , br [] []
                , input [ class "input", id "prep-time", name "prep-time", type_ "text", onInput PrepTimeChanged ] []
                , br [] []
                , label [ class "input-label" ] [ text "Schwierigkeitsgrad:" ]
                , br [] []
                , select [ class "input", id "difficulty", name "difficulty", onInput DifficultyChanged ]
                    [ option [] [ text "leicht" ]
                    , option [] [ text "mittel" ]
                    , option [] [ text "schwer" ]
                    ]
                , br [] []
                , label [ class "input-label" ] [ text "Kategorien:" ]
                , br [] []
                , input [ class "input", id "categories", name "categories", type_ "text", onInput CategoriesChanged ] []
                , br [] []
                , label [ class "input-label" ] [ text "Vorbereitungsschritte:" ]
                , br [] []
                , input [ class "input", id "preparation-steps", name "preparation-steps", type_ "number", attribute "min" "1", value (String.fromInt model.preparationSteps), onInput PreparationStepsChanged ] []
                , br [] []
                , button [ class "submit-button", type_ "submit", onClick SaveRecipe ] [ text "Rezept speichern" ]
                ]
            ]
        , div [ class "recipe-container" ]
            [ h2 [ class "recipe-title" ] [ text "Gespeichertes Rezept:" ]
            , case model.savedRecipe of
                Just recipe ->
                    p [ class "saved-recipe" ] [ text recipe ]

                Nothing ->
                    p [] [ text "Kein Rezept gespeichert" ]
            ]
    ]
