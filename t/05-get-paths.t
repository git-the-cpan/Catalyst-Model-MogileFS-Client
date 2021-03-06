#!perl

use lib qw(inc t/lib);

use Test::More;
use Catalyst::Model::MogileFS::Client;

use Test::Catalyst::Model::MogileFS::Client::Utils;

plan tests => 2;

SKIP: {
	my $utils;

	eval {
		$utils = Test::Catalyst::Model::MogileFS::Client::Utils->new;
	};
	if ($@) {
		skip( "Maybe not running mogilefsd, " . $@, 2 );
	}

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
}
