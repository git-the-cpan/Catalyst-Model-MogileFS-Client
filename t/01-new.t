#!perl

use lib qw(t/lib);

use Test::Base;
use Catalyst::Model::MogileFS::Client;
use Test::Catalyst::Model::MogileFS::Client::Utils;

plan tests => 2;

my $utils = Test::Catalyst::Model::MogileFS::Client::Utils->new;

{
		$utils->create_domain_unless_exists;

		my $mogile = Catalyst::Model::MogileFS::Client->new({
				domain => $utils->domain,
				hosts => $utils->hosts
		});

		ok(UNIVERSAL::isa($mogile, 'Catalyst::Model::MogileFS::Client'), 'create Catalyst::Model::MogileFS::Client instance');
		ok(UNIVERSAL::isa($mogile->client, 'MogileFS::Client'), 'create MogileFS::Client instance');

		$utils->delete_domain;
}
