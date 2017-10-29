#!/usr/bin/env perl

use strict;
use warnings;
use YAML qw(LoadFile);

sub getYAML {
  open(my $yfh, shift) || die "[ERROR] Couldn't open YAML file: $!\n";
  return LoadFile($yfh);
}

sub flatten {
  my $feed = shift;
  for my $bots (keys %$feed){
    if($bots !~ /^gid_/){
      my @temp;
      for my $value (@{$feed->{$bots}}){
        if(ref($value) eq 'ARRAY') {
          for my $inner (@{$value}) { push @temp, $inner; }
        } else { push @temp, $value; }
      }
      $feed->{$bots} = \@temp;
    }
  }
  return $feed;
}

die "invalid number of arguments\n" if(scalar @ARGV > 2 or scalar @ARGV <= 0);

my $feed = getYAML($ARGV[0]);
$feed = flatten($feed);
print $feed->{$ARGV[1]}->[int(rand(scalar @{$feed->{$ARGV[1]}}))];
