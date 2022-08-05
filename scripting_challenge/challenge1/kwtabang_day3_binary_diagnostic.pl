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
#					/p/dhvio/fe/peer_learning/scripting_challenge/challenge1/puzzle_input.txt
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
my $inputFile = "./puzzle_input.txt";
my $testFile = "./testInput_day3.txt";
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

# Determine how many bits to work on
my $numBits = getNumberOfBits($$IN[0]);

# Initialize Counter
for (my $i=0; $i<$numBits; $i++) {
	$cntArr[$i] = 0;		
}

# Check each bit
# If 0, subtract 1 from counter
# If 1, add 1 to counter
foreach my $line (@$IN) {
	chomp($line);
	my @bitArr = split(//,$line);

	for (my $i=0; $i<$numBits; $i++) {
		if ($bitArr[$i] == 0) {
			$cntArr[$i]--;
		} else {
			$cntArr[$i]++;
		}
	}
}

# Go through counter array
# If counter < 0, set gamma 0, epsilon 1
# If counter > 1, set gamma 1, epsilon 0
# If counter == 0, set both to X
for (my $i=0; $i<$numBits; $i++) {
	if ($cntArr[$i] < 0) {
		$gamArr[$i] = 0;
		$epsArr[$i] = 1;
	} 
	elsif ($cntArr[$i] > 0) {
		$gamArr[$i] = 1;
		$epsArr[$i] = 0;
	}
	else {
		printE("Count for bit position '$i' == 0\n");
		$gamArr[$i] = 'X';
		$epsArr[$i] = 'X';
	}
}

# Join gamma/epsilon arrays to get gamma/epsilon final binary number
my $gammaBin   = join('',@gamArr);
my $epsilonBin = join('',@epsArr);

# Convert binaries to decimal
my $gamma = convertBinary2Decimal($gammaBin);
my $epsilon = convertBinary2Decimal($epsilonBin);

# Calculate power consumption
my $powerCons = $gamma * $epsilon;

# Print results
printI("Gamma   : $gammaBin ($gamma)\n");
printI("Epsilon : $epsilonBin ($epsilon)\n");
printI("Power Consumption : $powerCons\n");


###################
##  SUBROUTINES  ##
###################

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
		"input=s"    => \$inputFile
	);  

	if ($test) {
		$inputFile = $testFile;
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

