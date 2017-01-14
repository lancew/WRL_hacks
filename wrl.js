'use strict';

/*Global localStorage:false, $:false */
var Limit = $.url().param('limit') || localStorage.getItem('limit') || 3;
var Country = $.url().param('country') || localStorage.getItem('country') || '';
if ($.url().param('top')) {
    Country = '';
    Limit = $.url().param('top');
}

// Add the new Judobase widget for the country.
$(function() {
    var LocalCountry = Country === '' ? 'ijf' : Country;
    $('#judobase').html(
    '<iframe height="350px"'
    + 'scrolling="no"'
    + 'width="200px"'
    + 'frameborder="0"'
    + 'src="https://data.judobase.org/widget/latest_videos/'
    + LocalCountry.toLowerCase()
    + '?age=sen"></iframe>'
    );
});
$.getJSON('https://data.judobase.org/api/'
        + 'get_json?params[action]=country.get_list',
        function(data) {
            var html = '';
            $.each(data, function(key, value) {
                html += countryFlagHTML(value);
            });
            $('#nations').html(html);
        });

$.getJSON('https://data.judobase.org/api/get_json'
        + '?params[action]=wrl.by_category'
        + '&params[category_limit]='
        + Limit,
        function(data) {
            var TotalAthletes = 0;
            var BottomMover = {
                Change: '',
                Athlete: '',
            };
            var TopFemale = {
                points: 0,
                athlete: '',
            };
            var TopMale = {
                points: 0,
                athlete: '',
            };
            var TopMover = {
                Change: '',
                Athlete: '',
            };

            if ($.url().param('country')) {
                localStorage.setItem('country', '' + $.url().param('country'));
            }

            if ($.url().param('limit')) {
                localStorage.setItem('limit', $.url().param('limit'));
            }

            $.each(data.categories, function(index, value) {
                $('#text').append('<h2>' + value.name + '</h2>');
                $.each(value.competitors, function(index2, athlete) {
                    if (athlete.country_short === Country || Country === '') {
                        var Delta = Math.abs(athlete.place_prev - athlete.place);
                        var DeltaText;
                        if (athlete.place < athlete.place_prev) {
                            // Climbing
                            DeltaText = '&#8599;' + Delta + ' position(s)';
                            if (BottomMover.Change < Delta) {
                                BottomMover.Change = Delta;
                                BottomMover.DeltaText = DeltaText;
                                BottomMover.Athlete = athlete;
                            }
                        } else if (athlete.place > athlete.place_prev) {
                            // Falling
                            DeltaText = '&#8600;' + Delta + ' position(s)';
                            if (TopMover.Change < Delta) {
                                TopMover.Change = Delta;
                                TopMover.DeltaText = DeltaText;
                                TopMover.Athlete = athlete;
                            }
                        } else {
                            Delta = '';
                            DeltaText = '&#8594; No change in position.';

                        }
                        if (athlete.gender === 'f'
                            && Number(athlete.points) > Number(TopFemale.points)
        ) {
                            TopFemale = athlete;
                        }
                        if (athlete.gender === 'm'
            && Number(athlete.points) > Number(TopMale.points)
        ) {
                            TopMale = athlete;
                        }

                        $('#text').append(athlete.place
                        + ') '
                        + athlete.family_name
                        + ', '
                        + athlete.given_name
                        + ' ('
                        + athlete.country_short
                        + ') '
                        + DeltaText
                        + ' ('
                        + athlete.points
                        + ' points) '
                        + '<br />');
                        TotalAthletes++;
                    }
                });
                $('#loading').html('');
            });

            if (TopMover.Athlete) {
                $('#no1_faller').html(
                    TopMover.DeltaText
                    + '  positions: <br />'
                    + TopMover.Athlete.family_name
                    + ' '
                    + TopMover.Athlete.given_name
                    + ' '
                    + TopMover.Athlete.weight_name);
            }
            if (BottomMover.Athlete) {
                $('#no1_climber').html(
                BottomMover.DeltaText
                + '  positions  <br />'
                + BottomMover.Athlete.family_name
                + ' '
                + BottomMover.Athlete.given_name
                + ' '
                + BottomMover.Athlete.weight_name);
            }
            if (TopMale.points) {
                $('#top_male').html(
                    TopMale.family_name
                    + ' '
                    + TopMale.given_name
                    + ' '
                    + TopMale.points + ' points'
                );
            }
            if (TopFemale.points) {
                $('#top_female').html(
                    TopFemale.family_name
                    + ' '
                    + TopFemale.given_name
                    + ' '
                    + TopFemale.points + ' points'
                );
            }

            $('#total_athletes').html(TotalAthletes);

            if (Country) {
                $('#country').html('<img src="blank.gif"'
                    + 'class="flag flag-'
                    + Country
                    + '" alt="'
                    + Country
                    + ' flag"> <span>'
                    + Country
                    + '</span>');
            }

        });


function countryFlagHTML(value) {
    if (!value.ioc.search('OJU|PJC|EJU|AJU|JUA|IJF')) {
        return '';
    }
    return '<li>'
    + '<img src="blank.gif"'
    + 'class="flag flag-'
    + value.ioc
    + '" alt="'
    + Country
    + ' flag"> <span>'
    + '<a href="/?country='
    + value.ioc + '&limit=9999">'
    + value.name + '</a></li>';
}
