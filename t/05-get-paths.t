#!perl

use lib qw(t/lib);

use Test::Base;
use Catalyst::Model::MogileFS::Client;
use Test::Catalyst::Model::MogileFS::Client::Utils;

plan tests => 2;

my $utils = Test::Catalyst::Model::MogileFS::Client::Utils->new;

{
		$utils->create_domain_unless_exists;

		my $key = 'test.key';
		my $content = 'foo bar baz';

		my $mogile = Catalyst::Model::MogileFS::Client->new({
				domain => $utils->domain,
				hosts => $utils->hosts
		});

		my $bytes = $mogile->store_content($key, $utils->class, $content);
		my @paths = $mogile->get_paths($key);

		ok(@paths > 0, 'path count');
		ok($mogile->delete($key), 'delete file');

		$utils->delete_domain;
}
