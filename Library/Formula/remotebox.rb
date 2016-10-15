require 'formula'

class Remotebox < Formula
  homepage 'https://nobgoblin.org.uk/'
  url 'http://knobgoblin.org.uk/downloads/RemoteBox-1.6.tar.bz2'
  sha1 '3e73e722f1bfddae04b9465d28b1958d2caf0ee0'


  depends_on 'SOAP::Lite' 		=> :perl
  depends_on 'Gtk2'				=> :perl
  depends_on 'rdesktop'			=> :recommended

<<<<<<< HEAD
  def patches
  	# Perl script uses $Bin which does not resolve to symlink. 
  	# Change to #RealBin - resolve symlink - and proper paths
  	DATA
  end
  
  def install
    bin.install Dir['remotebox']
	prefix.install Dir['*']
  end
end

__END__
--- bin/remotebox	2013-10-19 15:45:38.000000000 +0800
+++ bin/remotebox	2013-10-29 01:06:31.000000000 +0800
@@ -3,19 +3,19 @@
 # RemoteBox v1.6 (c) 2010-2013 Ian Chapman. Licenced under the terms of the GPL
 use strict;
 use warnings;
-use FindBin qw($Bin);
+use FindBin qw($RealBin);
 use POSIX qw(ceil);
 use File::Basename;
 use File::Spec;
 use MIME::Base64;
 # *** PACKAGERS MAY WISH TO PATCH THIS LOCATION ***
-use lib "$Bin/share/remotebox";
+use lib "$RealBin/../share/remotebox";
 # *************************************************
 use vboxService qw($endpoint $fault :all);
 
 # *** PACKAGERS MAY WISH TO PATCH THESE LOCATIONS ***
-our $sharedir = "$Bin/share/remotebox";
-our $docdir   = "$Bin/docs";
+our $sharedir = "$RealBin/../share/remotebox";
+our $docdir   = "$RealBin/../docs";
 # ***************************************************
 
 require 'vboxserializers.pl';
=======

  def install
    prefix.install Dir['*']
    bin.mkdir
	bin.install 'remotebox'
  end
end
>>>>>>> 6b1b4e5ece6dafbb2ef7101fa690608a81b662e7
