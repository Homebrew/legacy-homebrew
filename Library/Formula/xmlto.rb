class Xmlto < Formula
  desc "Convert XML to another format (based on XSL or other tools)"
  homepage "https://fedorahosted.org/xmlto/"
  url "https://fedorahosted.org/releases/x/m/xmlto/xmlto-0.0.28.tar.bz2"
  sha256 "1130df3a7957eb9f6f0d29e4aa1c75732a7dfb6d639be013859b5c7ec5421276"

  bottle do
    cellar :any_skip_relocation
    sha256 "25c7921f993a9cc8c4b9e2bd8a4e6f1a90b7f755f747b55f391ed063f123f64d" => :el_capitan
    sha256 "add17a1f3fd3569e3a8ed9e970f5d9397bdf1cca185c47b50af4f56492f8afff" => :yosemite
    sha256 "afd12ae6c79db17692175c1da036fbcf3df0c33592c0c6d7a686ce37f2443838" => :mavericks
  end

  depends_on "docbook"
  depends_on "docbook-xsl"
  # Doesn't strictly depend on GNU getopt, but OS X system getopt(1)
  # does not support longopts in the optstring, so use GNU getopt.
  depends_on "gnu-getopt"

  # xmlto forces --nonet on xsltproc, which causes it to fail when
  # DTDs/entities aren't available locally.
  patch :DATA

  def install
    # GNU getopt is keg-only, so point configure to it
    ENV["GETOPT"] = Formula["gnu-getopt"].opt_prefix/"bin/getopt"
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end


__END__
--- xmlto-0.0.25/xmlto.in.orig
+++ xmlto-0.0.25/xmlto.in
@@ -209,7 +209,7 @@
 export VERBOSE
 
 # Disable network entities
-XSLTOPTS="$XSLTOPTS --nonet"
+#XSLTOPTS="$XSLTOPTS --nonet"
 
 # The names parameter for the XSLT stylesheet
 XSLTPARAMS=""
