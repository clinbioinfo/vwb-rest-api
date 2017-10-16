#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use File::Copy;
use File::Path;
use lib "$FindBin::Bin/../lib";
use lib "/home/sundaramj/perl5/lib/perl5/x86_64-linux-gnu-thread-multi";
use lib "/home/sundaramj/perl5/perlbrew/perls/perl-5.24.0/lib/site_perl/5.24.0";

use Plack::Builder;

use VWB::REST::Logger;
use VWB::REST::Config::Manager;
use VWB::REST::DBUtil::Factory;

use VWB::REST::App;

use constant TRUE => 1;
use constant FALSE => 0;

use constant DEFAULT_VERBOSE => FALSE;
use constant DEFAULT_LOG_LEVEL => 4;

use constant SESSION_TOKEN => time();
use constant DEFAULT_OUTDIR => './output/' . SESSION_TOKEN;

use constant DEFAULT_CONFIG_FILE => "$FindBin::Bin/../conf/app_config.ini";

# use constant DEFAULT_ENVIRONMENT => '__DEFAULT_DATABASE_ENVIRONMENT__';
use constant DEFAULT_ENVIRONMENT => 'bdmprd2';
use constant DEFAULT_ACCOUNT_TYPE => 'publisher';

my $environment = DEFAULT_ENVIRONMENT;
my $account_type = DEFAULT_ACCOUNT_TYPE;

## See the BEGIN block below
my $oracle_home;

my $outdir = DEFAULT_OUTDIR;
if (!-e $outdir){
	mkpath($outdir) || die "Could not create output directory '$outdir' : $!";
}

my $logfile =  $outdir . '/' . File::Basename::basename($0) . '.log';

my $log_dir = File::Basename::dirname($logfile);

if (!-e $log_dir){
    mkpath($log_dir) || die "Could not create directory '$log_dir' : $!";
}

if ((-e $logfile) && (-s $logfile)){
    my $bakfile = $logfile . '.bak';
    copy($logfile, $bakfile) || die "Could not backup '$logfile' to '$bakfile' : $!";
}

my $config_file = DEFAULT_CONFIG_FILE;

&checkInfileStatus($config_file);

my $logger = new VWB::REST::Logger(
    logfile   => $logfile, 
    log_level => DEFAULT_LOG_LEVEL);

if (!defined($logger)){
    die "Could not instantiate VWB::REST::Logger";
}

$logger->info("Going to instantiate VWB::REST::Config::Manager");

## Instantiate the Config::Manager singleton here
## so that is available to the rest of the system.
my $cm = VWB::REST::Config::Manager::getInstance(
    config_file => $config_file,
    environment => $environment
    );

if (!defined($cm)){
    $logger->logdie("Could not instantiate VWB::REST::Config::Manager");
}

$logger->info("Going to instantiate VWB::REST::Manager");

my $manager = VWB::REST::Manager::getInstance(
    config_file => $config_file,
    environment => $environment,
    logfile     => $logfile,
    log_level   => DEFAULT_LOG_LEVEL,
    outdir      => $outdir
    );

if (!defined($manager)){
  $logger->logdie("Could not instantiate VWB::REST::Manager");
}

$logger->info("Going to launch the App");

VWB::REST::App->to_app;

##-----------------------------------------------------------
##
##    END OF MAIN -- SUBROUTINES FOLLOW
##
##-----------------------------------------------------------

sub checkInfileStatus {

    my ($infile) = @_;

    if (!defined($infile)){
        die ("infile was not defined");
    }

    my $errorCtr = 0 ;

    if (!-e $infile){
        print STDERR ("input file '$infile' does not exist\n");
        $errorCtr++;
    }
    else {

        if (!-f $infile){
            print STDERR ("'$infile' is not a regular file\n");

            $errorCtr++;
        }

        if (!-r $infile){
            print STDERR ("input file '$infile' does not have read permissions\n");
            $errorCtr++;
        }
        
        if (!-s $infile){
            print STDERR ("input file '$infile' does not have any content\n");
            $errorCtr++;
        }
    }
     
    if ($errorCtr > 0){
        print ("Encountered issues with input file '$infile'\n");
        exit(1);
    }
}


sub checkOutdirStatus {

    my ($outdir) = @_;

    if (!-e $outdir){
        
        mkpath($outdir) || die "Could not create output directory '$outdir' : $!";
        
        print STDERR "Created output directory '$outdir'\n";

    }
    
    if (!-d $outdir){
        print STDERR "'$outdir' is not a regular directory\n";
    }
}