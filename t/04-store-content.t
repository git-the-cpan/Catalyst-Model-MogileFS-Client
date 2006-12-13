#!perl

use lib qw(inc t/lib);

use Test::Base;
use Catalyst::Model::MogileFS::Client;
use Test::Catalyst::Model::MogileFS::Client::Utils;

plan tests => 3;

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
		is($bytes, length($content), 'stored file size test');
		is(${$mogile->get_file_data($key)}, $content, 'compare content');
		ok($mogile->delete($key), 'delete file');

		$utils->delete_domain;
}
