"use strict";
var limit = $.url().param('limit') || 3;
$.getJSON('http://data.judobase.org/api/get_json?params[action]=country.get_list', function(data) {
    var html = '';
    $.each(data, function(key, value) {
        if (!value.ioc.search('OJU|PJC|EJU|AJU|JUA')) {
            return true;
        }
        html += '<li><a href="http://lancew.github.io/WRL_hacks/?country=' + value.ioc + '&limit=9999">' + value.name + '</a></li>';
    });
    $('#nations').html(html);
});
$.getJSON('http://data.judobase.org/api/get_json?params[action]=wrl.by_category&params[category_limit]=' + limit, function(data) {
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
        points: 0,
        athlete: '',
    };
    $.each(data.categories, function(index, value) {
        $('#text').append('<h2>' + value.name + '</h2>');
        $.each(value.competitors, function(index2, athlete) {
            if (athlete.country_short == $.url().param('country') || !$.url().param('country')) {
                var delta = Math.abs(athlete.place - athlete.place_prev);
                if (athlete.place < athlete.place_prev) {
                    delta = '&#8593;' + delta + ' position(s)';
                    if (bottom_mover.change < delta) {
                        bottom_mover.change = delta;
                        bottom_mover.athlete = athlete;
                    }
                } else if (athlete.place > athlete.place_prev) {
                    delta = '&#8595;' + delta + ' position(s)';
                    if (top_mover.change < delta) {
                        top_mover.change = delta;
                        top_mover.athlete = athlete;
                    }
                } else {
                    delta = '';
                }
                if (athlete.gender === 'f' && Number(athlete.points) > Number(top_female.points)) {
                    top_female = athlete;
                }
                if (athlete.gender === 'm' && Number(athlete.points) > Number(top_male.points)) {
                    top_male = athlete;
                }

                $('#text').append(athlete.place + ') ' + athlete.family_name + ', ' + athlete.given_name + ' (' + athlete.country_short + ') ' + delta + ' (' + athlete.points + ' points) ' + '<br />');
                total_athletes++;
            }
        });
        $('#loading').html('');
    });

    if (top_mover.athlete && bottom_mover.athlete) {
        $('#no1_faller').html(
            top_mover.change + '  positions ' + top_mover.athlete.family_name + ' ' + top_mover.athlete.given_name + ' ' + top_mover.athlete.weight_name);

        $('#no1_climber').html(
            bottom_mover.change + '  positions ' + bottom_mover.athlete.family_name + ' ' + bottom_mover.athlete.given_name + ' ' + bottom_mover.athlete.weight_name);
    }
    if (top_male.points) {
        $('#top_male').html(
            top_male.family_name + ' ' + top_male.given_name + ' ' + top_male.points + ' points'
        );
    }
    if (top_female.points) {
        $('#top_female').html(
            top_female.family_name + ' ' + top_female.given_name + ' ' + top_female.points + ' points'
        );
    }
    $('#total_athletes').html(total_athletes);
    if ($.url().param('country')) {
        $('#country').html($.url().param('country'));
    }

});