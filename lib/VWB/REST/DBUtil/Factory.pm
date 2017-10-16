package VWB::REST::DBUtil::Factory;

use Moose;

use VWB::REST::Logger;
# use VWB::REST::MySQL::DBUtil;
# use VWB::REST::Postgresql::DBUtil;
use VWB::REST::MongoDB::DBUtil;
# use VWB::REST::SQLite::DBUtil;


use constant TRUE  => 1;
use constant FALSE => 0;

use constant DEFAULT_TYPE => 'mongodb';

## Singleton support
my $instance;

has 'type' => (
    is         => 'rw',
    isa        => 'Str',
    writer     => 'setType',
    reader     => 'getType',
    required   => FALSE,
    default    => DEFAULT_TYPE
    );

has 'database' => (
    is         => 'rw',
    isa        => 'Str',
    writer     => 'setDatabase',
    reader     => 'getDatabase',
    required   => FALSE,
    );

sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::REST::DBUtil::Factory(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::REST::DBUtil::Factory";
        }
    }

    return $instance;
}

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);

    $self->{_logger}->info("Instantiated " . __PACKAGE__);
}

sub _initLogger {

    my $self = shift;

    my $logger = Log::Log4perl->get_logger(__PACKAGE__);
    if (!defined($logger)){
        confess "logger was not defined";
    }

    $self->{_logger} = $logger;
}

sub _getType {

    my $self = shift;
    my (%args) = @_;

    my $type = $self->getType();

    if (!defined($type)){

        if (( exists $args{type}) && ( defined $args{type})){
            $type = $args{type};
        }
        elsif (( exists $self->{_type}) && ( defined $self->{_type})){
            $type = $self->{_type};
        }
        else {
            $self->{_logger}->logconfess("type was not defined");
        }

        $self->setType($type);
    }

    return $type;
}

sub _getDatabase {

    my $self = shift;
    my (%args) = @_;

    my $database = $self->getDatabase();

    if (!defined($database)){

        if (( exists $args{database}) && ( defined $args{database})){
            $database = $args{database};
        }
        elsif (( exists $self->{_database}) && ( defined $self->{_database})){
            $database = $self->{_database};
        }
        else {
            $self->{_logger}->logconfess("database was not defined");
        }

        $self->setDatabase($database);
    }

    return $database;
}

sub create {

    my $self = shift;
    

    my $type = $self->getType();
    if (!defined($type)){
        $self->{_logger}->logconfess("type was not defined");
    }

    if (lc($type) eq 'mongodb'){

        my $dbutil = VWB::REST::MongoDB::DBUtil::getInstance(@_);
        if (!defined($dbutil)){
            $self->{_logger}->logconfess("dbutil was not defined");
        }

        return $dbutil;
    }
    # elsif (lc($type) eq 'postgresql'){

    #     my $dbutil = VWB::REST::Postgresql::DBUtil::getInstance(@_);
    #     if (!defined($dbutil)){
    #         $self->{_logger}->logconfess("dbutil was not defined");
    #     }

    #     return $dbutil;
    # }
    # elsif (lc($type) eq 'sqlite'){

    #     my $dbutil = VWB::REST::SQLite::DBUtil::getInstance(@_);
    #     if (!defined($dbutil)){
    #         $self->{_logger}->logconfess("dbutil was not defined");
    #     }

    #     return $dbutil;
    # }
    # elsif (lc($type) eq 'mysql'){

    #     my $dbutil = VWB::REST::MySQL::DBUtil::getInstance(@_);
    #     if (!defined($dbutil)){
    #         $self->{_logger}->logconfess("dbutil was not defined");
    #     }

    #     return $dbutil;
    # }
    else {
        $self->{_logger}->logconfess("Unsupported database type '$type'");
    }


}

no Moose;
__PACKAGE__->meta->make_immutable;


__END__


=head1 NAME

 VWB::REST::DBUtil::Factory

 A module factory for creating DBUtil instances.

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::REST::DBUtil::Factory;
 my $factory = VWB::REST::DBUtil::Factory::getIntance();
 my $dbutil = $factory->create('mongodb');

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut