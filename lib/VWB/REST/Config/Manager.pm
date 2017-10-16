package VWB::REST::Config::Manager;

use Moose;
use Carp;
use FindBin;

use VWB::REST::Config::File::INI::Parser;

use constant TRUE => 1;
use constant FALSE => 0;

use constant DEFAULT_CONFIG_FILE => "$FindBin::Bin/../conf/app_config.ini";

has 'config_file' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setConfigFile',
    reader   => 'getConfigFile',
    required => FALSE,
    default  => DEFAULT_CONFIG_FILE
    );

## Singleton support
my $instance;


sub BUILD {

    my $self = shift;

    $self->_initParser(@_);
}

sub _initParser {

    my $self = shift;

    my $parser = VWB::REST::Config::File::INI::Parser::getInstance(@_);

    if (!defined($parser)){

        confess "Could not instantiate VWB::REST::Config::File::INI::Parser";
    }

    $self->{_parser} = $parser;
}

sub getInstance {

    if (!defined($instance)){
        $instance = new VWB::REST::Config::Manager(@_);
        if (!defined($instance)){
            confess "Could not instantiate VWB::REST::Config::Manager";
        }
    }

    return $instance;
}

sub getAdminEmail {

    my $self = shift;
    return $self->{_parser}->getAdminEmail(@_);
}

sub getAdminEmailAddress {

    my $self = shift;
    return $self->getAdminEmailAddresses(@_);
}

sub getAdminEmailAddresses {

    my $self = shift;
    return $self->{_parser}->getAdminEmailAddresses(@_);
}

sub getOutdir {

    my $self = shift;

    return $self->{_parser}->getOutdir(@_);
}

sub getLogLevel {

    my $self = shift;

    return $self->{_parser}->getLogLevel(@_);
}

sub getMailHost {

    my $self = shift;

    return $self->{_parser}->getMailHost(@_);
}

sub getAuthuser {

    my $self = shift;

    return $self->{_parser}->getAuthuser(@_);
}

sub getSubject {

    my $self = shift;

    return $self->{_parser}->getSubject(@_);
}

sub getTimeOut {

    my $self = shift;

    return $self->{_parser}->getTimeOut(@_);
}

sub getUrlBase {

    my $self = shift;

    return $self->{_parser}->getUrlBase(@_);
}

sub getDatabaseAdminUsername {

    my $self = shift;

    return $self->{_parser}->getDatabaseAdminUsername(@_);
}

sub getDatabaseAdminPassword {

    my $self = shift;

    return $self->{_parser}->getDatabaseAdminPassword(@_);
}

sub getDatabaseServer {

    my $self = shift;

    return $self->{_parser}->getDatabaseServer(@_);
}

sub getDatabaseName {

    my $self = shift;

    return $self->{_parser}->getDatabaseName(@_);
}

no Moose;
__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

 VWB::REST::Config::Manager

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::REST::Config::Manager;
 my $cm = VWB::REST::Config::Manager::getInstance();
 $cm->getAdminEmail();

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

 new
 _init
 DESTROY
 getInstance

=over 4

=cut