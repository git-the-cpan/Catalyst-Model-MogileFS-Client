#!perl

use lib qw(inc t/lib);

use Test::Base;
use Catalyst::Model::MogileFS::Client;
use Test::Catalyst::Model::MogileFS::Client::Utils;

plan tests => 4;

my $utils = Test::Catalyst::Model::MogileFS::Client::Utils->new;

{
		$utils->create_domain_unless_exists;

		my $key = 'test.key';
		my $content = 'Hello World';

		my $mogile = Catalyst::Model::MogileFS::Client->new({
				domain => $utils->domain,
				hosts => $utils->hosts
		});

		my $fh = $mogile->new_file($key, $utils->class);

		ok($fh, 'get file handle');
		ok(UNIVERSAL::isa($fh, 'IO::Handle'), 'isa IO::Handle');
		print $fh $content;
		$fh->close;

		is(${$mogile->get_file_data($key)}, $content, 'compare file content');
		ok($mogile->delete($key), 'delete file');

		$utils->delete_domain;
}
