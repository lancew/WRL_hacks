var limit = $.url().param( 'limit' ) || 3;
$.getJSON( 'http://restcountries.eu/rest/v1/all', function( data ) {
    var html = '';
    $.each( data, function( key, value ) {
        html += '<li>&nbsp;<a href="http://lancew.github.io/WRL_hacks/?country=' + value.alpha3Code + '&&limit=9999" class="glyphicon glyphicon-unchecked">' + value.name + '</a></li>';
    });
    $( '#nations' ).html( html );
});
$.getJSON( 'http://data.judobase.org/api/get_json?params[action]=wrl.by_category&params[category_limit]=' + limit, function( data ) {
    var total_athletes = 0;
    var top_mover = {
        change: '',
        athlete: ''
    };
    var top_male = {
        points: 0,
        athlete: '',
    };
    var top_female = {
        points: 0,
        athlete: '',
    };
    var bottom_mover = {
        change: '',
        athlete: ''
    };
    var top_scorer = {
        points : 0,
        athlete : '',
    };
    $.each( data.categories, function( index, value ) {
        $( '#text' ).append( '<h2>' + value.name + '</h2>' );
        $.each( value.competitors, function( index2, athlete ) {
            if ( athlete.country_short == $.url().param( 'country' ) || !$.url().param( 'country' ) ) {
                delta = Math.abs( athlete.place - athlete.place_prev );
                if ( athlete.place < athlete.place_prev ) {
                    delta = '&#8593;' + delta + ' position(s)';
                    if ( bottom_mover.change < delta ) {
                        bottom_mover.change = delta;
                        bottom_mover.athlete = athlete;
                    }
                } else if ( athlete.place > athlete.place_prev ) {
                    delta = '&#8595;' + delta + ' position(s)';
                    if ( top_mover.change < delta ) {
                        top_mover.change = delta;
                        top_mover.athlete = athlete;
                    }
                } else {
                    delta = '';
                }
                if (athlete.points > top_scorer.points){
                    top_scorer.points = athlete.points;
                    top_scorer.athlete = athlete;
                }
                if (athlete.gender == 'f' && athlete.points > top_female.points) { 
                    top_female = athlete;
                }
                if (athlete.gender == 'm' && athlete.points > top_male.points) { 
                    top_male = athlete;
                }
                console.log(athlete);
                $( '#text' ).append( athlete.place
                + ') '
                + athlete.family_name
                + ', '
                + athlete.given_name
                + ' ('
                + athlete.country_short
                + ') '
                + delta
                + ' ('
                + athlete.points
                + ' points) '
                + '<br />'
                );
                total_athletes++;
            }
        });
        $( '#loading' ).html( '' );
    });
    
    if ( top_mover.athlete && bottom_mover.athlete ) {
        $( '#no1_faller' ).html( '<p>Top Faller: '
        + top_mover.change
        + '  positions '
        + top_mover.athlete.family_name
        + ' '
        + top_mover.athlete.given_name
        + ' '
        + top_mover.athlete.weight_name );
        $( '#no1_climber' ).html( '<p>Top Climber: '
        + bottom_mover.change
        + '  positions '
        + bottom_mover.athlete.family_name
        + ' '
        + bottom_mover.athlete.given_name
        + ' '
        + bottom_mover.athlete.weight_name );
    }
                $( '#top_scorer' ).html(' <p> Top Scorer: '
                        + top_scorer.athlete. family_name
                        + ' '
                        + top_scorer.athlete.given_name
                        + ': '
                        + top_scorer.points
                        + '</p>'

                );
        $('#top_male').html('<p> Top Male: '
            + top_male.family_name
            + ' '
            + top_male.given_name
            + ' '
            + top_male.points
            + ' points</p>'
        );        
        $('#top_female').html('<p> Top Female: '
            + top_female.family_name
            + ' '
            + top_female.given_name
            + ' '
            + top_female.points
            + ' points</p>'
        );        

        $('#total_athletes').html('<p> Total Athletes: '
            + total_athletes
            + '</p>'
            );


    console.log(top_scorer);
});
