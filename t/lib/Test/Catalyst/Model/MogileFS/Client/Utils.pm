package Test::Catalyst::Model::MogileFS::Client::Utils;

use strict;
use warnings;

use base qw/Class::Accessor::Fast/;

use MogileFS::Admin;

our $MOGILE_TEST_HOSTS = ($ENV{MOGILE_TEST_HOSTS}) ? [split(/\s+/, $ENV{MOGILE_TEST_HOSTS})] : ['127.0.0.1:7001'];
our $MOGILE_TEST_DOMAIN = $ENV{MOGILE_TEST_DOMAIN} || "test.domain";
our $MOGILE_TEST_CLASS = $ENV{MOGILE_TEST_CLASS} || "test.class";

__PACKAGE__->mk_accessors(qw/admin hosts domain class/);

sub new {
		my ($class, $args) = @_;

		$args = {} unless ($args);
		$args->{hosts} ||= $MOGILE_TEST_HOSTS;
		$args->{domain} ||= $MOGILE_TEST_DOMAIN;
		$args->{class} ||= $MOGILE_TEST_CLASS;

		my $self = $class->SUPER::new($args);
		$self->admin(MogileFS::Admin->new(hosts => $args->{hosts}));

		return $self;
}

sub create_domain_unless_exists {
		my ($self, $domain) = @_;
		$domain ||= $self->domain;

		unless ($self->is_exists_domain) {
				$self->admin->create_domain($domain);
				$self->admin->create_class($domain);
		}
}

sub delete_domain {
		my ($self, $domain) = @_;
		$domain ||= $self->domain;

		if ($self->is_exists_domain) {
				$self->admin->delete_domain($domain);
		}
}

sub is_exists_domain {
		my ($self, $domain) = @_;
		$domain ||= $self->domain;

		my $domains = $self->admin->get_domains;

		return (exists $domains->{$domain}) ? 1 : 0;
}

sub create_class {
		my ($self, $domain, $class, $mindevcount) = @_;

		$domain ||= $self->domain;
		$class ||= $self->class;
		$mindevcount ||= 2;

		return $self->admin->create_class($domain, $class, $mindevcount);
}

sub delete_class {
		my ($self, $domain, $class) = @_;

		$domain ||= $self->domain;
		$class ||= $self->class;

		return $self->admin->delete_class($domain, $class);
}

1;
