use strict;
use warnings;
use v5.10;

use LWP::Simple;               # From CPAN
use JSON qw( decode_json );    # From CPAN
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

my $base_url = 'http://data.judobase.org/api/get_json?';
my $event_id = $ARGV[0] || 1455;    # 2017 Europeans

my $event = decode_json(
    get(      $base_url
            . 'params[action]=general.get_one'
            . '&params[module]=competition'
            . '&params[id]='
            . $event_id
    )
);

my $contests = decode_json(
    get(      $base_url
            . 'params[action]=contest.find'
            . '&params[id_competition]='
            . $event_id
            . '&params[id_weight]=0'
            . '&params[order_by]=cnum'
    )
)->{contests};

my %categories;

say
    'category,round,winner,ijf_id_winner,dob_winner,country_winner,wrl_points_winner,belt_winner,loser,ijf_id_loser,dob_loser,country_loser,wrl_points_loser,belt_loser';

for ( @{$contests} ) {
    $categories{ $_->{weight} }{ $_->{id_ijf_blue} }++;
    $categories{ $_->{weight} }{ $_->{id_ijf_white} }++;

    next
        unless $_->{round_name} eq 'Final'
        || $_->{round_name} eq 'Bronze'
        || $_->{round_name} eq 'Semi-Final';

    my $athlete_blue = decode_json(
        get(      $base_url
                . 'params[action]=competitor.info'
                . '&params[id_person]='
                . $_->{id_person_blue}
        )
    );

    my $athlete_white = decode_json(
        get(      $base_url
                . 'params[action]=competitor.info'
                . '&params[id_person]='
                . $_->{id_person_white}
        )
    );

    my $wrl_blue = decode_json(
        get(      $base_url
                . 'params[action]=competitor.wrl_history'
                . '&params[id_person]='
                . $_->{id_person_blue}
        )
    );

    my $wrl_white = decode_json(
        get(      $base_url
                . 'params[action]=competitor.wrl_history'
                . '&params[id_person]='
                . $_->{id_person_white}
        )
    );

    my @facts;
    push @facts, $_->{weight};
    push @facts, $_->{round_name};

    if ( $_->{id_winner} == $_->{id_person_blue} ) {
        push @facts, $_->{person_blue};
        push @facts, $_->{id_ijf_blue};
        push @facts, $athlete_blue->{birth_date};
        push @facts, $wrl_blue->[-1]{sum_points};
        push @facts, $_->{country_blue};
        push @facts, 'Blue';
        push @facts, $_->{person_white};
        push @facts, $_->{id_ijf_white};
        push @facts, $athlete_white->{birth_date};
        push @facts, $wrl_white->[-1]{sum_points};
        push @facts, $_->{country_white};
        push @facts, 'White';
    }
    else {
        push @facts, $_->{person_white};
        push @facts, $_->{id_ijf_white};
        push @facts, $athlete_white->{birth_date};
        push @facts, $wrl_white->[-1]{sum_points};
        push @facts, $_->{country_white};
        push @facts, 'White';
        push @facts, $_->{person_blue};
        push @facts, $_->{id_ijf_blue};
        push @facts, $athlete_blue->{birth_date};
        push @facts, $wrl_blue->[-1]{sum_points};
        push @facts, $_->{country_blue};
        push @facts, 'Blue';
    }

    say join ',', @facts;
    #warn Dumper $_;
}

say '';

for ( sort keys %categories ) {
    my %athletes = %{ $categories{$_} };
    say $_ . ',' . scalar keys %athletes;
}

say $event->{title};
say $event->{year};
say $event->{country};

