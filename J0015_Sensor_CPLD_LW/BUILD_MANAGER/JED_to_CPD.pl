use strict;
#use warnings;

#############################################################################
# File: JED_to_CPD.pl                                                       #
# Author: Tom Magdeburger                                                   #
# Date: 8/14/2017                                                           #
#                                                                           #
# This PERL script converts a Lattice JED file to a CPD(ASCII) file format  #
#                                                                           #
# Works with Lattice Diamond version 3.8.0.115.3                            #
#                                                                           #
# Usage:  Perl JED_to_CPD.pl <JED_in_file.jed> > <CPD_out_file.cpd>         #
#############################################################################


my $ln = 1;
my $store;
my @rec1;
my @byte;

while (<>) {
  binmode STDOUT;  # else you get a CR wherever a LN is found!!
  if ( ($ln >= 130) && ($ln <= 11389 - 2048 ) ) {
    chop;    
    for (my $indx=0; $indx < 16; $indx++) {
      my $bits = substr $_, ($indx * 8), 8;
      my $byte = sprintf("%01.2x", oct( "0b$bits"));
      if ($indx%2 == 1) {
        #print "$indx: $byte $store\n";
        push @rec1, "$byte ";
        push @rec1, "$store ";
      } else {
        $store = $byte;
      } 
    }
    #print @rec1;
    #print "\n";    
    print map {chr hex} @rec1;
    @rec1 = ();
  }
  $ln++
} 

__END__  
    
