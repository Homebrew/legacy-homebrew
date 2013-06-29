require 'formula'

class Sloccount < Formula
  homepage 'http://www.dwheeler.com/sloccount/'
  url 'http://www.dwheeler.com/sloccount/sloccount-2.26.tar.gz'
  sha1 '505031c6adfb93e454aaf8b0ee7de04122079d13'

  depends_on 'md5sha1sum'

  def patches
    DATA
  end

  def install
    rm "makefile.orig" # Delete makefile.orig or patch falls over
    bin.mkpath # Create the install dir or install falls over
    system "make", "install", "PREFIX=#{prefix}"
    (bin+'erlang_count').write "#!/bin/sh\ngeneric_count '%' $@"
  end
end

__END__
diff --git a/break_filelist b/break_filelist
index ad2de47..ff854e0 100755
--- a/break_filelist
+++ b/break_filelist
@@ -205,6 +205,7 @@ $noisy = 0;            # Set to 1 if you want noisy reports.
   "hs" => "haskell", "lhs" => "haskell",
    # ???: .pco is Oracle Cobol
   "jsp" => "jsp",  # Java server pages
+  "erl" => "erlang",
 );
