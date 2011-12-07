require 'formula'

class Colordiff < Formula
  url 'http://colordiff.sourceforge.net/colordiff-1.0.9.tar.gz'
  homepage 'http://colordiff.sourceforge.net/'
  md5 '31864847eaa4e900f72bbb6bbc64f1ec'

  def patches
    # Fixes the path to colordiffrc.
    # Uses git-diff colors due to Git popularity.
    # Improves wdiff support through better regular expressions.
    DATA end

  def install
    bin.install "colordiff.pl" => "colordiff"
    bin.install "cdiff.sh" => "cdiff"
    etc.install "colordiffrc"
    etc.install "colordiffrc-lightbg"
    man1.install "colordiff.1"
    man1.install "cdiff.1"
  end
end
__END__
diff --git 1/a/colordiff.pl 2/b/colordiff.pl
index 9e74e5c..c0649aa 100755
--- a/colordiff.pl
+++ b/colordiff.pl
@@ -23,6 +23,7 @@

 use strict;
 use Getopt::Long qw(:config pass_through);
+use File::Basename;
 use IPC::Open2;

 my $app_name     = 'colordiff';
@@ -63,7 +64,7 @@ my $cvs_stuff  = $colour{green};

 # Locations for personal and system-wide colour configurations
 my $HOME   = $ENV{HOME};
-my $etcdir = '/etc';
+my $etcdir = dirname(__FILE__) . "/../etc";
 my ($setting, $value);
 my @config_files = ("$etcdir/colordiffrc");
 push (@config_files, "$ENV{HOME}/.colordiffrc") if (defined $ENV{HOME});
@@ -418,8 +419,8 @@ foreach (@inputstream) {
         }
     }
     elsif ($diff_type eq 'wdiff') {
-        $_ =~ s/(\[-[^]]*?-\])/$file_old$1$colour{off}/g;
-        $_ =~ s/(\{\+[^]]*?\+\})/$file_new$1$colour{off}/g;
+        $_ =~ s/(\[-([^-]*(-[^]])?)*-\])/$file_old$1$colour{off}/g;
+        $_ =~ s/(\{\+([^+]*(\+[^}])?)*\+\})/$file_new$1$colour{off}/g;
     }
     elsif ($diff_type eq 'debdiff') {
         $_ =~ s/(\[-[^]]*?-\])/$file_old$1$colour{off}/g;
diff --git 1/a/colordiffrc 2/b/colordiffrc
index 6e75b2b..7712014 100644
--- a/colordiffrc
+++ b/colordiffrc
@@ -20,7 +20,7 @@ color_patches=no
 # this, use the default output colour"
 #
 plain=off
-newtext=blue
+newtext=green
 oldtext=red
-diffstuff=magenta
-cvsstuff=green
+diffstuff=cyan
+cvsstuff=magenta
