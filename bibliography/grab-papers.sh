#!/usr/bin/perl
use List::Util qw(pairs);
@PAPERS = qw(
    watts2002simple         http://www.stat.berkeley.edu/~aldous/260-FMIE/Papers/watts.pdf
    newman2003structure     http://epubs.siam.org/doi/pdf/10.1137/S003614450342480
    milgram1969note         https://www.dropbox.com/s/ij30vedzdinljpo/milgram1969note.pdf?raw=1
);
for (pairs @PAPERS) {
    ($name, $url) = @$_;
    $file = "papers/$name.pdf";
    system 'wget', '-O', $file, $url unless -e $file;
}
