class Fop < Formula
  desc "XSL-FO print formatter for making PDF or PS documents"
  homepage "https://xmlgraphics.apache.org/fop/index.html"
  url "https://www.apache.org/dyn/closer.cgi?path=/xmlgraphics/fop/binaries/fop-2.0-bin.tar.gz"
  sha256 "1e90cfc9e07c2da088592860fa4651a7640c9e1e3500b71a613a5dea03eb3665"

  bottle do
    cellar :any_skip_relocation
    sha256 "045c5ece618205ac658e61aac6b76c1295c819bbdb2fa812e324f3ada15ef6bc" => :el_capitan
    sha256 "eec4b2d93c9a4f2e75b18cd1bdb68851df2a34e58ca3bbba68a2b046b735625f" => :yosemite
    sha256 "b5b8cdf1a93d104f5927e4916684e97ea91092fcf9525caa929d55ff15822e2b" => :mavericks
    sha256 "6cceeca2b10749a6e5457bbbb9156ed7d026a80a71fdfe30ff7a588cbb8e259d" => :mountain_lion
  end

  resource "hyph" do
    url "https://downloads.sourceforge.net/project/offo/offo-hyphenation-utf8/0.1/offo-hyphenation-fop-stable-utf8.zip"
    sha256 "0b4e074635605b47a7b82892d68e90b6ba90fd2af83142d05878d75762510128"
  end

  # fixes broken default java path as in
  # http://svn.apache.org/viewvc/ant/core/trunk/src/script/ant?r1=1238725&r2=1434680&pathrev=1434680&view=patch
  patch :DATA

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"fop"
    resource("hyph").stage do
      (libexec/"build").install "fop-hyph.jar"
    end
  end

  test do
    (testpath/"test.xml").write "<name>Homebrew</name>"
    (testpath/"test.xsl").write <<-EOS.undent
      <?xml version="1.0" encoding="utf-8"?>
      <xsl:stylesheet version="1.0"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:fo="http://www.w3.org/1999/XSL/Format">
        <xsl:output method="xml" indent="yes"/>
        <xsl:template match="/">
          <fo:root>
            <fo:layout-master-set>
              <fo:simple-page-master master-name="A4-portrait"
                    page-height="29.7cm" page-width="21.0cm" margin="2cm">
                <fo:region-body/>
              </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="A4-portrait">
              <fo:flow flow-name="xsl-region-body">
                <fo:block>
                  Hello, <xsl:value-of select="name"/>!
                </fo:block>
              </fo:flow>
            </fo:page-sequence>
          </fo:root>
        </xsl:template>
      </xsl:stylesheet>
    EOS
    system bin/"fop", "-xml", "test.xml", "-xsl", "test.xsl", "-pdf", "test.pdf"
    File.exist? testpath/"test.pdf"
  end
end

__END__
diff --git a/fop b/fop
index aca642b..1cae344 100755
--- a/fop
+++ b/fop
@@ -81,7 +81,11 @@ case "`uname`" in
   CYGWIN*) cygwin=true ;;
   Darwin*) darwin=true
            if [ -z "$JAVA_HOME" ] ; then
-             JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home
+               if [ -x '/usr/libexec/java_home' ] ; then
+                   JAVA_HOME=`/usr/libexec/java_home`
+               elif [ -d "/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home" ]; then
+                   JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home
+               fi
            fi
            ;;
 esac
