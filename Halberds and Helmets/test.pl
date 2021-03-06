#!/bin/env perl
use Modern::Perl '2015';
use Test::More;
open(my $fh, '<:encoding(UTF-8)', 'Halberds-and-Helmets-Ref-Guide.ltx')
    or die "Cannot read file: $!";
my @lines = <$fh>;
ok(@lines > 0, "file was read");

my %index;
for (@lines) {
  if (/^\\makeindex.name=([a-z]+)/) { $index{$1}++; }
}

ok(keys %index, "index entries were found");
for my $index (keys %index) {
  ok(grep(/^\\newcommand\{\\$index\}/, @lines), "\\$index command defined");
}
for my $index (keys %index) {
  ok(grep(/^\\printindex\[$index\]/, @lines), "$index index is printed");
}

my $section;
my %h;
for (@lines) {
  if (/^\\section\{([a-zA-Z, ]+)\}/) { $section = $1; %h = () };
  if (/^\\([a-z]+)\{([^\}]+)\}/) {
    if($index{$1}) {
      like($section, qr/^$2/, "$section starts with $2 in the $1 index"); 
      $h{$1} = 1;
    }
  }
  if (/^\\textbf\{Terrain\}: ([a-z, ]+)/) {
    my @tags = split(/, /, $1);
    for my $tag (@tags) {
      ok($h{$tag}, "\\$tag exists for $section");
    }
    for my $key (keys %h) {
      next if $key eq 'animal';
      ok(grep(/^$key/, @tags), "terrain $key is listed in $section (@tags)");
    }
  }
}

done_testing;
