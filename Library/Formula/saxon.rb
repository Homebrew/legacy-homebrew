class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "http://saxon.sourceforge.net"
  url "https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.6/SaxonHE9-6-0-7J.zip"
  version "9.6.0.7"
  sha256 "0c904b886c7512a288c38474ff5f92042b7c3c1440352f5c919aa54f3811ab66"

  bottle :unneeded

  def install
    libexec.install Dir["*.jar", "doc", "notices"]
    bin.write_jar_script libexec/"saxon9he.jar", "saxon"
  end

  test do
    (testpath/"test.xml").write <<-XML.undent
      <test>It works!</test>
    XML
    (testpath/"test.xsl").write <<-XSL.undent
      <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
        <xsl:template match="/">
          <html>
            <body>
              <p><xsl:value-of select="test"/></p>
            </body>
          </html>
        </xsl:template>
      </xsl:stylesheet>
    XSL
    assert_equal <<-HTML.undent.chop, shell_output("#{bin}/saxon test.xml test.xsl")
      <html>
         <body>
            <p>It works!</p>
         </body>
      </html>
    HTML
  end
end
