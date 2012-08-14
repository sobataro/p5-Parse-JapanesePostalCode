#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use 5.014;
use lib 'lib';
use Parse::JapaneseZipCode;

binmode STDOUT => 'utf8';

my $ken_all = shift;

my $parser = Parse::JapaneseZipCode->new( file => $ken_all );
while (my $obj = $parser->fetch_obj) {
    my @line = map { defined $_ ? $_ : '' } map { $obj->$_ } qw/
        region_id old_zip zip
        pref_kana city_kana town_kana build_kana
        pref city town build floor
        is_multi_zip has_koaza_banchi has_chome is_multi_town
        update_status update_reason
    /;
    say join "\t", map { "[$_]" } @line;
    next unless $obj->has_subtown;
    print "\t";
    say join "/", @{ $obj->subtown };
}
