class Snownews < Formula
  desc "Text mode RSS newsreader"
  homepage "https://kiza.eu/software/snownews"
  url "https://kiza.eu/media/software/snownews/snownews-1.5.12.tar.gz"
  sha256 "26dd96e9345d9cbc1c0c9470417080dd0c3eb31e7ea944f78f3302d7060ecb90"
  revision 1

  option "without-nls", "Build without translations"

  depends_on "gettext" if build.with? "nls"
  depends_on "openssl"

  # Fix system openssl linking error on OS X.
  # Allow EXTRA_LDFLAGS to take precedence so we can link brewed openssl
  # instead of deprecated system openssl.
  # Upstream has been notified but has no public bug tracker
  patch :DATA

  def install
    args = ["--prefix=#{prefix}"]
    args << "--disable-nls" if build.without? "nls"

    system "./configure", *args
    # Must supply -lz because snownews configure relies on "xml2-config --libs" for
    # it, which doesn't work on OS X prior to 10.11
    system "make", "install", "EXTRA_LDFLAGS=#{ENV.ldflags} -L#{Formula["openssl"].opt_lib} -lz", "CC=#{ENV.cc}"
  end
end

__END__
diff --git a/configure b/configure
index a752cd6..74e61d7 100755
--- a/configure
+++ b/configure
@@ -13,7 +13,7 @@ chomp($xmlldflags);
 
 my $prefix = "/usr/local";
 my $cflags = "-Wall -Wno-format-y2k -O2 -DLOCALEPATH=\"\\\"\$(LOCALEPATH)\\\"\" -DOS=\\\"$os\\\" $xmlcflags \$(EXTRA_CFLAGS) ";
-my $ldflags = "-lncurses -lcrypto $xmlldflags \$(EXTRA_LDFLAGS) ";
+my $ldflags = "\$(EXTRA_LDFLAGS) -lncurses -lcrypto $xmlldflags ";
 
 my $use_nls = 1;
 parse_cmdl_line();
