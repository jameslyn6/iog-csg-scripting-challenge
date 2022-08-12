#!/usr/intel/bin/perl 
#===============================================================================
#
#         FILE:  binary_diagnostic.pl
#
#        USAGE:  ./binary_diagnostic.pl [-test]
#
#  DESCRIPTION:  This is the solution for the problem given here:
#					https://adventofcode.com/2021/day/3
#				 Given this input file:
#					/p/dhvio/fe/peer_learning/scripting_challenge/puzzle_input.txt
#
#      OPTIONS:  -test  Enables the example shown to test code working
#
#       AUTHOR:  Krystina Tabangcura (kwtabang), krystina.w.tabangcura@intel.com
#      COMPANY:  Intel, DCAI/IOG/PMEM/CSG
#      VERSION:  1.0
#      CREATED:  07/20/22 13:38:02
#     REVISION:  ---
#===============================================================================

#########################
##  BUILT-IN INCLUDES  ##
#########################

use strict;
use warnings;
use FileHandle;
use Data::Dumper;
use Getopt::Long;

#######################
##  CUSTOM INCLUDES  ##
#######################

########################
##  GLOBAL VARIABLES  ##
########################

my $debug = 0;
my $test = 0;
my $myfile = 0;
my $inputFile = "./puzzle_input.txt";
my $myInputFile = "./day3_input.txt";
my $testInputFile = "./testInput_day3.txt";
my @cntArr;
my @gamArr;
my @epsArr;

############  
##  MAIN  ##
############

getOpts();

# Read in input file
printI("Input: $inputFile\n");
my $IN = readFile($inputFile);

# Determine ratings
my $oxygenRating = getRating("Oxygen", $IN);
my $co2Rating = getRating("Co2", $IN);

# Convert Ratings Binary to Decimal
my $oxygenDec = convertBinary2Decimal($oxygenRating);
my $co2Dec = convertBinary2Decimal($co2Rating);

# Calculate Life Support Rating
my $lifeSupportRating = $oxygenDec * $co2Dec;

# Print results
printI("Oxygen Rating		: $oxygenRating ($oxygenDec)\n");
printI("CO2 Rating			: $co2Rating ($co2Dec)\n");
printI("Life Support Rating : $lifeSupportRating\n");

###################
##  SUBROUTINES  ##
###################

# 1. do
# 2.	Foreach bit position
#			Initialize counter: my $c = 0;
# 3.		Foreach listofnum,
#				If bit == 0, subtract 1 from counter
#					save number to 0-bit list
#				If bit == 1, add 1 to counter
#					save number to 1-bit list
# 4.		If counter is negative (< 0)
#				If rating == oxygen, save 0-bit list to listofnum
#				If rating == co2,	 save 1-bit list to listofnum
# 5.		Else if counter is positive (> 0)
#				If rating == oxygen, save 1-bit list to listofnum
#				If rating == co2,	 save 0-bit list to listofnum
# 6.		Else (counter == 0)
#				If rating == oxygen, save 1-bit list to listofnum
#				If rating == co2,	 save 0-bit list to listofnum
# 7.		Break if listOfNum == 1
# 8. while scalar(listofnum) > 1		

#===============================================================================
#         NAME:  getRating
#      PURPOSE:  Get oxygen and co2 ratings
#===============================================================================

sub getRating {
	my $tmpRating = shift;
	my $IN = shift;
	my $rating = ($tmpRating eq "Oxygen") ? 1 : 0; 
	my @listOfNum = @$IN;
	# Oxygen == 1
	# Co2 == 0

	# Determine how many bits to work on
	my $numBits = getNumberOfBits($listOfNum[0]);
	my $numOfNum = scalar(@listOfNum);
	printD("Starting list of numbers: $numOfNum\n");
	
	do {
		for (my $i=0; $i<$numBits; $i++) {
			my $c = 0;
			my @saved0bit;
			my @saved1bit;
			printD("Looking at bit position $i (left to right)\n");

			foreach my $num (@listOfNum) {
				chomp($num);
				printD("  $num\n");
				my @numArr = split(//,$num);
				
				if ($numArr[$i] == 0) {
					$c--;
					push(@saved0bit, $num);
				} 
				else {
					$c++;
					push(@saved1bit, $num);
				}
			}
			my $msg = "";

			if ($c < 0) {
				@listOfNum = $rating ? @saved0bit : @saved1bit;
				$msg	   = $rating ? "saved 0 bits" : "saved 1 bits";			

			} elsif ($c > 0) {
				@listOfNum = $rating ? @saved1bit : @saved0bit;
				$msg	   = $rating ? "saved 1 bits" : "saved 0 bits";			

			} else { # $c == 0
				@listOfNum = $rating ? @saved1bit : @saved0bit;
				$msg	   = $rating ? "(c == 0) saved 1 bits" : "(c == 0) saved 0 bits";			
			}
			printD("Count is: ${c}... $msg\n");
			printD("Numbers remaining: ".scalar(@listOfNum)."\n\n");
			last if (scalar(@listOfNum) == 1);
		}
	} while (scalar(@listOfNum) > 1);

	return $listOfNum[0];
}

#===============================================================================
#         NAME:  getNumberOfBits
#      PURPOSE:  Determine number of bits in binary number
#===============================================================================

sub getNumberOfBits {
	my $binNum = shift;
	chomp($binNum);
	my @arr = split(//,$binNum);

	return scalar(@arr);	
}

#===============================================================================
#         NAME:  convertBinary2Decimal
#      PURPOSE:  Converts given binary number to decimal
#===============================================================================

sub convertBinary2Decimal {
	my $binNum = shift;
	my @binArr = split(//,$binNum);
	my $numBits = scalar(@binArr);
	my $index = scalar(@binArr) - 1;

	my $decimal = 0;

	foreach (my $i=0; $i<$numBits; $i++) {
		my $power = $index - $i;
		my $tmp;	
	
		if ($power == 0) {
			$tmp = $binArr[$i] == 0 ? 0 : 1;
		} else {
			$tmp = ($binArr[$i] * 2) ** $power;
			#print "($binArr[$i] * 2) ** $power = $tmp\n";
			#print "$decimal\n";
		}
		$decimal = $decimal + $tmp;
	} 
	return $decimal;
}

#===============================================================================
#         NAME:  getOpts
#      PURPOSE:  Parse command line options
#===============================================================================

sub getOpts {
	my $result = GetOptions (
		"debug"   => \$debug,
		"test"    => \$test,
		"my"    => \$myfile,
		"input=s"    => \$inputFile
	);  

	if ($test) {
		$inputFile = $testInputFile;
	}

	if ($myfile) {
		$inputFile = $myInputFile;
	}
}

#===============================================================================
#         NAME:  dump2
#      PURPOSE:  Dump perl structure to a file
#===============================================================================

sub dump2 {
	my $hashref = shift;
	my $file = shift;

	$Data::Dumper::Indent = 1; # Values can be 0, 1, 2 (default), 3
		my $fh = new FileHandle($file, "w");

	if (defined $fh) {
		print $fh Data::Dumper->Dump([$hashref], ["*dump"]);
		$fh->close;
	}
}

#===============================================================================
#         NAME:  createFile
#      PURPOSE:  Pass file name, return filehandle
#===============================================================================

sub createFile {
	my $file = shift;
	my $fileFH = new FileHandle($file, "w");

	if (!defined $fileFH) {
		printE("Cannot create the following file:  $file\n");
		exit;
	}

	return $fileFH;
}

#===============================================================================
#         NAME:  readFile
#      PURPOSE:  Pass file name, return contents
#===============================================================================

sub readFile {
	my $file = shift;
	my $fileFH = new FileHandle($file, "r");
	my @lines;

	if (defined $fileFH) {
		@lines = <$fileFH>;
	}
	else {
		printE("Cannot access the following file:  $file\n");
		exit;
	}
	$fileFH->close;

	return \@lines;
}

#===============================================================================
#         NAME:  writeFile
#      PURPOSE:  Pass file name, file contents (array ref), write file, no return
#===============================================================================

sub writeFile {
	my $file = shift;
	my $contents = shift;
	my $fileFH = createFile($file);

	foreach my $line (@{$contents}) {
		chomp($line);
		print $fileFH "$line\n";
	}

	$fileFH->close();;
}

#===============================================================================
#         NAME:  printX
#      PURPOSE:  Standardize print messages
#===============================================================================

sub printD {
	my $line = shift;

	print "-D- $line" if ($debug);
}

sub printI {
	my $line = shift;

	print "-I- $line";
}

sub printW {
	my $line = shift;

	print "-W- $line";
}

sub printE {
	my $line = shift;

	print "-E- $line";
}

