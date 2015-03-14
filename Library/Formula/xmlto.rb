require 'formula'

class Xmlto < Formula
  homepage 'https://fedorahosted.org/xmlto/'
  url 'http://fedorahosted.org/releases/x/m/xmlto/xmlto-0.0.26.tar.bz2'
  sha1 'c5a982239c738c76d0e67bc416d835cf102cd422'

  bottle do
    cellar :any
    sha1 "1135350e4d76f2a2b6c86fc8554aa9bb7d2ca7d7" => :yosemite
    sha1 "62c44bc17acaf2be24d10ada48b87d0d41fab60c" => :mavericks
    sha1 "752ba9e2f015a8da4b4ab4e082493d010d49db86" => :mountain_lion
  end

  depends_on 'docbook'
  depends_on 'docbook-xsl'
  # Doesn't strictly depend on GNU getopt, but OS X system getopt(1)
  # does not suport longopts in the optstring, so use GNU getopt.
  depends_on 'gnu-getopt'

  # xmlto forces --nonet on xsltproc, which causes it to fail when
  # DTDs/entities aren't available locally.
  patch :DATA

  def install
    # GNU getopt is keg-only, so point configure to it
    ENV['GETOPT'] = Formula["gnu-getopt"].opt_prefix/"bin/getopt"
    # Find our docbook catalog
    ENV['XML_CATALOG_FILES'] = "#{etc}/xml/catalog"

    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
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
