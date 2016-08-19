#! /usr/bin/perl -w

#Input Files
$filename=$ARGV[0]; #SVG File
$filename2=$ARGV[1]; #Flux Gene
$filename3=$ARGV[2]; #SVG with flux

#Open the file with the desired metabolites and make a hash
#read in file of fluxes

open(INPUTFILE2, $filename2);
while (<INPUTFILE2>) {
          @data = split('\t', $_);
        #print $geneoid, "\t", $number, "\n";
        $rxn=$data[0];
           $flux=$data[2];
          chomp($rxn);
            chomp($flux);
            
            $rxn=~ s/\s//;
	  $hash{$rxn} = $flux;
	  
	  #print $rxn,"TEST", "\n";
	  
	  }
	  
my $max = 0;
$_ > $max and $max = $_ for values %hash;
print "Here is the max $max", "\n";	  
	  
#now divide all values by the max

foreach $key (keys %hash)  {

$hash{$key}=$hash{$key}/$max*3;

if (abs($hash{$key}) < 0.5  && abs($hash{$key}) > 0)  {

if ($hash{$key} >0) {
$hash{$key}=0.5;

}  else  {

$blah_blah=$hash{$key};

$hash{$key}=-0.5;

print "Here is the negative values ", $blah_blah, "\t", $hash{$key}, "\n";

}


}

}

foreach $key (keys %hash)  {

print $key, "\t", $hash{$key}, "\n";

}

#my $max = 0;
#$_ > $max and $max = $_ for values %hash;
#print "Here is the new max $max", "\n";	  	  
	  
print "done with hash", "\n";

$count=1;

$/ ="<path";

open (OLD, $filename);
@array=<OLD>;

open (NEW, ">$filename3");

foreach $line (@array) {

$count++;

if ($line=~ /id\=\"rxn[0-9]+.*?_[0-9]"/ | $line=~ /id\=\"EX_cpd[0-9]+.*?"/ )  {



	$id = $&;

	$id =~ s/_[0-9].*//;
	$id =~ s/id\=\"//;



	chomp($id);

		if (exists $hash{$id})  {



			$line2=$line;

			$abs=abs($hash{$id});


			$line2 =~ s/width\:.*?px/width\:$abs\.px/;
			$line2 =~ s/\.px/px/;


				if ($hash{$id} < 0)  {


					#print $id, "\t";
					#$line =~ /marker.*url.*?\)/;
					#print $&, "\t";
					if ($line2 =~ s/marker\-end\:url\(#Arrow1Lend\)/marker\-start\:url\(#Arrow1Lstart\)/) {

						#print "the end did it", "\t";

					} elsif ($line2 =~ s/marker\-start\:url\(#Arrow1Lstart\)/marker\-end\:url\(#Arrow1Lend\)/) {

						#print "the start did it", "\t";

					}

					#$line =~ /marker.*url.*?\)/;
					#print $&, "\n";


				} 
				

					print NEW $line2;

					 } else {
					 
					 $line2=$line;

			


			$line2 =~ s/width\:.*?px/width\:0px/;
			#$line2 =~ s/\.px/px/;

print NEW $line2;

}

#print "YES", "\n";

} else {

print NEW $line;

}


#if ($hash{$id} < 0)  {
}

print "the count is $count";
#$line2 =~ s

