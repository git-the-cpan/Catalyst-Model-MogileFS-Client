#!perl

use lib qw(t/lib lib);

use Test::Base;
use Catalyst::Model::MogileFS::Client;
use File::Slurp qw/slurp/;
use Test::Catalyst::Model::MogileFS::Client::Utils;

plan tests => 3;

my $utils = Test::Catalyst::Model::MogileFS::Client::Utils->new;

{
		$utils->create_domain_unless_exists;

		my $key = 'test.key';
		my $file = 'Makefile.PL';

		my $mogile = Catalyst::Model::MogileFS::Client->new({
				domain => $utils->domain,
				hosts => $utils->hosts
		});

		my $bytes = $mogile->store_file($key, $utils->class, $file);
		is($bytes, -s $file, 'stored file size test');
		is(${$mogile->get_file_data($key)}, slurp($file), 'compare file content');
		ok($mogile->delete($key), 'delete file');

		$utils->delete_domain;
}
