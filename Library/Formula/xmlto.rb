require 'formula'

class Xmlto < Formula
  homepage 'http://cyberelk.net/tim/software/xmlto/'
  url 'http://fedorahosted.org/releases/x/m/xmlto/xmlto-0.0.25.tar.bz2'
  sha1 '5d1aecd59d519066f94b4591722767c4e41bdc0f'

  bottle do
    cellar :any
    sha1 "429f1b6a3186432fb0a130d1ee003269af6fc9d9" => :yosemite
    sha1 "158eb206779654ac305d5948b79c950e64afaada" => :mavericks
    sha1 "611a524653264cd414c74b60c50d4522bb63d570" => :mountain_lion
  end

  depends_on 'docbook'
  depends_on 'docbook-xsl'
  depends_on 'gnu-getopt'

  # xmlto forces --nonet on xsltproc, which causes it to fail when
  # DTDs/entities aren't available locally.
  patch :DATA

  def install
    # GNU getopt is keg-only, so point configure to it
    ENV['GETOPT'] = Formula["gnu-getopt"].bin/"getopt"
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
