use strict;
#use warnings;

#############################################################################
# File: JED_to_CPD.pl for Power CPLD                                        #
# Author: Tom Magdeburger                                                   #
# Date: 2/27/2019                                                           #
#                                                                           #
# This PERL script converts a Lattice JED file to a CPD(ASCII) file format  #
#                                                                           #
# Works for DAIRCM Power CPLD, Lattice Diamond version 3.10.0.111.2         #
#                                                                           #
# Usage:  Perl JED_to_CPD.pl <JED_in_file.jed> > <CPD_out_file.cpd>         #
#############################################################################


my $ln = 1;
my $store;
my @rec1;
my @byte;

while (<>) {
  binmode STDOUT;  # else you get a CR wherever a LN is found!!

  #unless ( $ln == 1 | /^\D/ | /NOTE/ ) {  
  if ( ($ln >= 87) && ($ln <= 11349 - 2048 - 3 ) ) {
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
    
