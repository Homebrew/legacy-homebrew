require 'formula'

class Colordiff < Formula
  url 'http://colordiff.sourceforge.net/colordiff-1.0.9.tar.gz'
  homepage 'http://colordiff.sourceforge.net/'
  md5 '31864847eaa4e900f72bbb6bbc64f1ec'

  def patches
    DATA
  end

  def install
    bin.mkpath
    bin.install "colordiff.pl" => "colordiff"
    bin.install "cdiff.sh" => "cdiff"
    etc.mkpath
    etc.install "colordiffrc"
    etc.install "colordiffrc-lightbg"
    man1.mkpath
    man1.install "colordiff.1"
    man1.install "cdiff.1"
  end
end
__END__
--- a/colordiff.pl	2009-01-28 15:12:10.000000000 -0500
+++ b/colordiff.pl	2011-09-17 13:15:46.000000000 -0400
@@ -23,6 +23,7 @@
 
 use strict;
 use Getopt::Long qw(:config pass_through);
+use File::Basename;
 use IPC::Open2;
 
 my $app_name     = 'colordiff';
@@ -63,7 +64,7 @@
 
 # Locations for personal and system-wide colour configurations
 my $HOME   = $ENV{HOME};
-my $etcdir = '/etc';
+my $etcdir = dirname(__FILE__) . "/../etc";
 my ($setting, $value);
 my @config_files = ("$etcdir/colordiffrc");
 push (@config_files, "$ENV{HOME}/.colordiffrc") if (defined $ENV{HOME});
