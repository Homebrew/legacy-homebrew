class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "http://cloc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cloc/cloc/v1.64/cloc-1.64.pl"
  sha256 "79edea7ea1f442b1632001e23418193ae4571810e60de8bd25e491036d60eb3d"

  bottle do
    cellar :any
    sha256 "fd5ed31f8080c52f4db1f997e02173cc20f83adf671adcdac1cb42cc2c0e48fe" => :yosemite
    sha256 "56fc9b2baf7a18d1232640b0b6bdf2c0e63db11a27281504e13ce47684d253b3" => :mavericks
    sha256 "a4c159ceb7f5f67d7925864a8e4f31e2c43fe2dee356afdf931ebc1000ca11a3" => :mountain_lion
  end

  # remove deprecated defined(@array) to support perl 5.22 (bug 135)
  # remove "no warnings 'deprecated';" -- no longer relevant
  # don't write language definition for "(unknown)"
  # http://sourceforge.net/p/cloc/bugs/135/
  patch :DATA

  def install
    bin.install "cloc-#{version}.pl" => "cloc"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_match "1,C,0,0,4", shell_output("#{bin}/cloc --csv .")
  end
end

__END__
--- a/cloc-1.64.pl
+++ b/cloc-1.64.pl
@@ -1,4 +1,5 @@
 #!/usr/bin/env perl
+#!/usr/local/perl-5.22.0/bin/perl
 # cloc -- Count Lines of Code                  {{{1
 # Copyright (C) 2006-2015 Al Danial <al.danial@gmail.com>
 # First release August 2006
@@ -116,9 +117,6 @@
 use Text::Tabs qw { expand };
 use Cwd qw { cwd };
 use File::Glob;
-my $PERL_516 = $] >= 5.016 ? 1 : 0;  # 5.16 deprecates defined(@array)
-no warnings 'deprecated';            # will need to comment this out to test
-                                     # each new Perl version
 # 1}}}
 # Usage information, options processing.       {{{1
 my $ON_WINDOWS = 0;
@@ -1275,17 +1273,10 @@
         my $not_Filters_by_Language_Lang_LR = 0;
 #print "file_LR = [$file_L] [$file_R]\n";
 #print "Lang_LR = [$Lang_L] [$Lang_R]\n";
-        if ($PERL_516) {
             if (!(@{$Filters_by_Language{$Lang_L} }) or
                 !(@{$Filters_by_Language{$Lang_R} })) {
                 $not_Filters_by_Language_Lang_LR = 1;
             }
-        } else {
-            if (!defined(@{$Filters_by_Language{$Lang_L} }) or
-                !defined(@{$Filters_by_Language{$Lang_R} })) {
-                $not_Filters_by_Language_Lang_LR = 1;
-            }
-        }
         if ($not_Filters_by_Language_Lang_LR) {
             if (($Lang_L eq "(unknown)") or ($Lang_R eq "(unknown)")) {
                 $Ignored{$fh[$F  ]}{$file_L} = "language unknown (#1)";
@@ -1618,7 +1609,7 @@
         $Ignored{$file} = "--exclude-lang=$Language{$file}";
         next;
     }
-    my $Filters_by_Language_Language_file = !defined @{$Filters_by_Language{$Language{$file}} };
+    my $Filters_by_Language_Language_file = ! @{$Filters_by_Language{$Language{$file}} };
     if ($Filters_by_Language_Language_file) {
         if ($Language{$file} eq "(unknown)") {
             $Ignored{$file} = "language unknown (#1)";
@@ -1756,11 +1747,7 @@
                    )?
                    $}x) {
                 if ($report_type eq "by language") {
-                    if ($PERL_516) {
                         next unless         @{$rhaa_Filters_by_Language->{$1}};
-                    } else {
-                        next unless defined @{$rhaa_Filters_by_Language->{$1}};
-                    }
                     # above test necessary to avoid trying to sum reports
                     # of reports (which have no language breakdown).
                     $found_language = 1;
@@ -3001,7 +2988,8 @@
                 $language eq "Lisp/Julia"               or
                 $language eq "Perl/Prolog"              or
                 $language eq "D/dtrace"                 or
-                $language eq "IDL/Qt Project/Prolog";
+                $language eq "IDL/Qt Project/Prolog"    or
+                $language eq "(unknown)";
         printf $OUT "%s\n", $language;
         foreach my $filter (@{$rhaa_Filters_by_Language->{$language}}) {
             printf $OUT "    filter %s", $filter->[0];
@@ -3259,7 +3247,7 @@
 } # 1}}}
 sub print_language_filters {                 # {{{1
     my ($language,) = @_;
-    if (!defined @{$Filters_by_Language{$language}}) {
+    if (!@{$Filters_by_Language{$language}}) {
         warn "Unknown language: $language\n";
         warn "Use --show-lang to list all defined languages.\n";
         return;
@@ -4623,7 +4611,7 @@
 
   open (FILE, $file);
   while (<FILE>) {
-    if (m/^\\begin{code}/) { close FILE; return 2; }
+    if (m/^\\begin\{code\}/) { close FILE; return 2; }
     if (m/^>\s/) { close FILE; return 1; }
   }
 
@@ -4652,9 +4640,9 @@
             if (!s/^>//) { s/.*//; }
         } elsif ($literate == 2) {
             if ($inlitblock) {
-                if (m/^\\end{code}/) { s/.*//; $inlitblock = 0; }
+                if (m/^\\end\{code\}/) { s/.*//; $inlitblock = 0; }
             } elsif (!$inlitblock) {
-                if (m/^\\begin{code}/) { s/.*//; $inlitblock = 1; }
+                if (m/^\\begin\{code\}/) { s/.*//; $inlitblock = 1; }
                 else { s/.*//; }
             }
         }
@@ -6582,7 +6570,7 @@
         my $language = $rh_Language_by_Extension->{$ext};
         next if defined $extension_collisions{$language};
         next if $seen_it{$language};
-        if (!defined @{$rhaa_Filters_by_Language->{$language}}) {
+        if (!@{$rhaa_Filters_by_Language->{$language}}) {
             $OK = 0;
             warn "Missing language filter for $language\n";
         }
