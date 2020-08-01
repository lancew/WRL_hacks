module Countries exposing
    ( Country
    , fromCode, fromCodeCustom, search, searchCustom
    , all
    )

{-| A searchable [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1) based list of country names, codes and emoji flags.

The library is intended to be used qualified (i.e. `Countries.search`, `Countries.all`).

    > import Countries
    > Countries.fromCode "AU"
    Just { name = "Australia", code = "AU", flag = "🇦🇺" }
        : Maybe.Maybe Countries.Country

See the `examples` folder for a basic country picker example.

Note: [Country names do change](https://github.com/supermario/elm-countries/commit/0c0475df983c35f936a19c14383385ca4bc96cb5)! It's best to use the code as a key if you are using and storing country details outside of this library.


# Types

@docs Country


# Common helpers

@docs fromCode, fromCodeCustom, search, searchCustom


# Data set

@docs all

-}


{-| The Country record type.

  - name: The [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1) Country name
  - code: [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) two-letter Country code
  - flag: The Country's unicode emoji flag, see [Regional Indicator Symbol](https://en.wikipedia.org/wiki/Regional_Indicator_Symbol)

This type is intentionally not opaque, as accessing the countries reference data as easily as possible is the primary goal.

-}
type alias Country =
    { name : String
    , code : String
    , flag : String
    }


{-| Find a country by its [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) two-letter country code.
-}
fromCode : String -> Maybe Country
fromCode code =
    fromCodeCustom all code


{-| Find a country by its [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) two-letter country code, using a custom Countries list
-}
fromCodeCustom : List Country -> String -> Maybe Country
fromCodeCustom countries code =
    if String.length code /= 3 then
        Nothing

    else
        countries
            |> List.filter
                (\country ->
                    country.code == code
                )
            |> List.head


{-| Search all Countries by case-insensitive string matching on name and code
-}
search : String -> List Country
search searchString =
    searchCustom all searchString


{-| Search a custom Countries list by case-insensitive string matching on name and code
-}
searchCustom : List Country -> String -> List Country
searchCustom countries searchString =
    countries
        |> List.filter
            (\country ->
                String.contains
                    (String.toLower searchString)
                    (String.toLower <| country.name ++ country.code)
            )


{-| The full list of all 249 current [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1) Country records.
-}
all : List Country
all =
    [ ( "Andorra", "AND", "🇦🇩" )
    , ( "United Arab Emirates", "UAE", "🇦🇪" )
    , ( "Afghanistan", "AFG", "🇦🇫" )
    , ( "Antigua and Barbuda", "ANT", "🇦🇬" )
    , ( "Albania", "ALB", "🇦🇱" )
    , ( "Armenia", "ARM", "🇦🇲" )
    , ( "Angola", "ANG", "🇦🇴" )
    , ( "Argentina", "ARG", "🇦🇷" )
    , ( "American Samoa", "ASA", "🇦🇸" )
    , ( "Austria", "AUT", "🇦🇹" )
    , ( "Australia", "AUS", "🇦🇺" )
    , ( "Aruba", "ARU", "🇦🇼" )
    , ( "Azerbaijan", "AZE", "🇦🇿" )
    , ( "Bosnia and Herzegovina", "BIH", "🇧🇦" )
    , ( "Barbados", "BAR", "🇧🇧" )
    , ( "Bangladesh", "BAN", "🇧🇩" )
    , ( "Belgium", "BEL", "🇧🇪" )
    , ( "Burkina Faso", "BUR", "🇧🇫" )
    , ( "Bulgaria", "BUL", "🇧🇬" )
    , ( "Bahrain", "BRN", "🇧🇭" )
    , ( "Burundi", "BDI", "🇧🇮" )
    , ( "Benin", "BEN", "🇧🇯" )
    , ( "Bermuda", "BER", "🇧🇲" )
    , ( "Brunei Darussalam", "BRU", "🇧🇳" )
    , ( "Bolivia (Plurinational State of)", "BOL", "🇧🇴" )
    , ( "Brazil", "BRA", "🇧🇷" )
    , ( "Bahamas", "BAH", "🇧🇸" )
    , ( "Bhutan", "BHU", "🇧🇹" )
    , ( "Botswana", "BOT", "🇧🇼" )
    , ( "Belarus", "BLR", "🇧🇾" )
    , ( "Belize", "BIZ", "🇧🇿" )
    , ( "Canada", "CAN", "🇨🇦" )
    , ( "Congo, Democratic Republic of the", "COD", "🇨🇩" )
    , ( "Central African Republic", "CAF", "🇨🇫" )
    , ( "Congo", "CGO", "🇨🇬" )
    , ( "Switzerland", "SUI", "🇨🇭" )
    , ( "Côte d'Ivoire", "CIV", "🇨🇮" )
    , ( "Cook Islands", "COK", "🇨🇰" )
    , ( "Chile", "CHI", "🇨🇱" )
    , ( "Cameroon", "CMR", "🇨🇲" )
    , ( "China", "CHN", "🇨🇳" )
    , ( "Colombia", "COL", "🇨🇴" )
    , ( "Costa Rica", "CRC", "🇨🇷" )
    , ( "Cuba", "CUB", "🇨🇺" )
    , ( "Cabo Verde", "CPV", "🇨🇻" )
    , ( "Cyprus", "CYP", "🇨🇾" )
    , ( "Czechia", "CZE", "🇨🇿" )
    , ( "Germany", "GER", "🇩🇪" )
    , ( "Djibouti", "DJI", "🇩🇯" )
    , ( "Denmark", "DEN", "🇩🇰" )
    , ( "Dominica", "DMA", "🇩🇲" )
    , ( "Dominican Republic", "DOM", "🇩🇴" )
    , ( "Algeria", "ALG", "🇩🇿" )
    , ( "Ecuador", "ECU", "🇪🇨" )
    , ( "Estonia", "EST", "🇪🇪" )
    , ( "Egypt", "EGY", "🇪🇬" )
    , ( "Eritrea", "ERI", "🇪🇷" )
    , ( "Spain", "ESP", "🇪🇸" )
    , ( "Ethiopia", "ETH", "🇪🇹" )
    , ( "Finland", "FIN", "🇫🇮" )
    , ( "Fiji", "FIJ", "🇫🇯" )
    , ( "France", "FRA", "🇫🇷" )
    , ( "Gabon", "GAB", "🇬🇦" )
    , ( "United Kingdom of Great Britain and Northern Ireland", "GBR", "🇬🇧" )
    , ( "Grenada", "GRN", "🇬🇩" )
    , ( "Georgia", "GEO", "🇬🇪" )
    , ( "Ghana", "GHA", "🇬🇭" )
    , ( "Gambia", "GAM", "🇬🇲" )
    , ( "Guinea", "GUI", "🇬🇳" )
    , ( "Greece", "GRE", "🇬🇷" )
    , ( "Guatemala", "GUA", "🇬🇹" )
    , ( "Guam", "GUM", "🇬🇺" )
    , ( "Guinea-Bissau", "GBS", "🇬🇼" )
    , ( "Guyana", "GUY", "🇬🇾" )
    , ( "Hong Kong", "HKG", "🇭🇰" )
    , ( "Honduras", "HON", "🇭🇳" )
    , ( "Croatia", "CRO", "🇭🇷" )
    , ( "Haiti", "HAI", "🇭🇹" )
    , ( "Hungary", "HUN", "🇭🇺" )
    , ( "Indonesia", "INA", "🇮🇩" )
    , ( "Ireland", "IRL", "🇮🇪" )
    , ( "Israel", "ISR", "🇮🇱" )
    , ( "India", "IND", "🇮🇳" )
    , ( "Iraq", "IRQ", "🇮🇶" )
    , ( "Iran (Islamic Republic of)", "IRI", "🇮🇷" )
    , ( "Iceland", "ISL", "🇮🇸" )
    , ( "Italy", "ITA", "🇮🇹" )
    , ( "Jamaica", "JAM", "🇯🇲" )
    , ( "Jordan", "JOR", "🇯🇴" )
    , ( "Japan", "JPN", "🇯🇵" )
    , ( "Kenya", "KEN", "🇰🇪" )
    , ( "Kyrgyzstan", "KGZ", "🇰🇬" )
    , ( "Cambodia", "CAM", "🇰🇭" )
    , ( "Kiribati", "KIR", "🇰🇮" )
    , ( "Saint Kitts and Nevis", "SKN", "🇰🇳" )
    , ( "Korea (Democratic People's Republic of)", "PRK", "🇰🇵" )
    , ( "Korea, Republic of", "KOR", "🇰🇷" )
    , ( "Kuwait", "KUW", "🇰🇼" )
    , ( "Cayman Islands", "CAY", "🇰🇾" )
    , ( "Kazakhstan", "KAZ", "🇰🇿" )
    , ( "Lao People's Democratic Republic", "LAO", "🇱🇦" )
    , ( "Lebanon", "LBN", "🇱🇧" )
    , ( "Saint Lucia", "LCA", "🇱🇨" )
    , ( "Liechtenstein", "LIE", "🇱🇮" )
    , ( "Sri Lanka", "SRI", "🇱🇰" )
    , ( "Liberia", "LBR", "🇱🇷" )
    , ( "Lesotho", "LES", "🇱🇸" )
    , ( "Lithuania", "LTU", "🇱🇹" )
    , ( "Luxembourg", "LUX", "🇱🇺" )
    , ( "Latvia", "LAT", "🇱🇻" )
    , ( "Libya", "LBA", "🇱🇾" )
    , ( "Morocco", "MAR", "🇲🇦" )
    , ( "Monaco", "MON", "🇲🇨" )
    , ( "Moldova, Republic of", "MDA", "🇲🇩" )
    , ( "Montenegro", "MNE", "🇲🇪" )
    , ( "Madagascar", "MAD", "🇲🇬" )
    , ( "Marshall Islands", "MHL", "🇲🇭" )
    , ( "North Macedonia", "MKD", "🇲🇰" )
    , ( "Mali", "MLI", "🇲🇱" )
    , ( "Myanmar", "MYA", "🇲🇲" )
    , ( "Mongolia", "MGL", "🇲🇳" )
    , ( "Macao", "MAC", "🇲🇴" )
    , ( "Mauritania", "MTN", "🇲🇷" )
    , ( "Malta", "MLT", "🇲🇹" )
    , ( "Mauritius", "MRI", "🇲🇺" )
    , ( "Maldives", "MDV", "🇲🇻" )
    , ( "Malawi", "MAW", "🇲🇼" )
    , ( "Mexico", "MEX", "🇲🇽" )
    , ( "Malaysia", "MAS", "🇲🇾" )
    , ( "Mozambique", "MOZ", "🇲🇿" )
    , ( "Namibia", "NAM", "🇳🇦" )
    , ( "Niger", "NIG", "🇳🇪" )
    , ( "Nigeria", "NGR", "🇳🇬" )
    , ( "Nicaragua", "NCA", "🇳🇮" )
    , ( "Netherlands", "NED", "🇳🇱" )
    , ( "Norway", "NOR", "🇳🇴" )
    , ( "Nepal", "NEP", "🇳🇵" )
    , ( "Nauru", "NRU", "🇳🇷" )
    , ( "New Zealand", "NZL", "🇳🇿" )
    , ( "Oman", "OMA", "🇴🇲" )
    , ( "Panama", "PAN", "🇵🇦" )
    , ( "Peru", "PER", "🇵🇪" )
    , ( "Papua New Guinea", "PNG", "🇵🇬" )
    , ( "Philippines", "PHI", "🇵🇭" )
    , ( "Pakistan", "PAK", "🇵🇰" )
    , ( "Poland", "POL", "🇵🇱" )
    , ( "Puerto Rico", "PUR", "🇵🇷" )
    , ( "Palestine, State of", "PLE", "🇵🇸" )
    , ( "Portugal", "POR", "🇵🇹" )
    , ( "Palau", "PLW", "🇵🇼" )
    , ( "Paraguay", "PAR", "🇵🇾" )
    , ( "Qatar", "QAT", "🇶🇦" )
    , ( "Romania", "ROU", "🇷🇴" )
    , ( "Serbia", "SRB", "🇷🇸" )
    , ( "Russian Federation", "RUS", "🇷🇺" )
    , ( "Rwanda", "RWA", "🇷🇼" )
    , ( "Saudi Arabia", "KSA", "🇸🇦" )
    , ( "Solomon Islands", "SOL", "🇸🇧" )
    , ( "Seychelles", "SEY", "🇸🇨" )
    , ( "Sudan", "SUD", "🇸🇩" )
    , ( "Sweden", "SWE", "🇸🇪" )
    , ( "Singapore", "SGP", "🇸🇬" )
    , ( "Slovenia", "SLO", "🇸🇮" )
    , ( "Slovakia", "SVK", "🇸🇰" )
    , ( "Sierra Leone", "SLE", "🇸🇱" )
    , ( "San Marino", "SMR", "🇸🇲" )
    , ( "Senegal", "SEN", "🇸🇳" )
    , ( "Somalia", "SOM", "🇸🇴" )
    , ( "Suriname", "SUR", "🇸🇷" )
    , ( "South Sudan", "SSD", "🇸🇸" )
    , ( "Sao Tome and Principe", "STP", "🇸🇹" )
    , ( "El Salvador", "ESA", "🇸🇻" )
    , ( "Syrian Arab Republic", "SYR", "🇸🇾" )
    , ( "Chad", "CHA", "🇹🇩" )
    , ( "Togo", "TOG", "🇹🇬" )
    , ( "Thailand", "THA", "🇹🇭" )
    , ( "Tajikistan", "TJK", "🇹🇯" )
    , ( "East Timor", "TLS", "🇹🇱" )
    , ( "Turkmenistan", "TKM", "🇹🇲" )
    , ( "Tunisia", "TUN", "🇹🇳" )
    , ( "Tonga", "TGA", "🇹🇴" )
    , ( "Turkey", "TUR", "🇹🇷" )
    , ( "Trinidad and Tobago", "TTO", "🇹🇹" )
    , ( "Tuvalu", "TUV", "🇹🇻" )
    , ( "Tanzania, United Republic of", "TAN", "🇹🇿" )
    , ( "Ukraine", "UKR", "🇺🇦" )
    , ( "Uganda", "UGA", "🇺🇬" )
    , ( "United States of America", "USA", "🇺🇸" )
    , ( "Uruguay", "URU", "🇺🇾" )
    , ( "Uzbekistan", "UZB", "🇺🇿" )
    , ( "Saint Vincent and the Grenadines", "VIN", "🇻🇨" )
    , ( "Venezuela (Bolivarian Republic of)", "VEN", "🇻🇪" )
    , ( "Viet Nam", "VIE", "🇻🇳" )
    , ( "Vanuatu", "VAN", "🇻🇺" )
    , ( "Samoa", "SAM", "🇼🇸" )
    , ( "Yemen", "YEM", "🇾🇪" )
    , ( "South Africa", "RSA", "🇿🇦" )
    , ( "Zambia", "ZAM", "🇿🇲" )
    , ( "Zimbabwe", "ZIM", "🇿🇼" )
    ]
        |> List.map (\( name, code, flag ) -> Country name code flag)
