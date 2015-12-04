class XalanC < Formula
  desc "XSLT processor"
  homepage "https://xalan.apache.org/xalan-c/"
  url "https://www.apache.org/dyn/closer.cgi?path=xalan/xalan-c/sources/xalan_c-1.11-src.tar.gz"
  sha256 "4f5e7f75733d72e30a2165f9fdb9371831cf6ff0d1997b1fb64cdd5dc2126a28"

  bottle do
    cellar :any
    sha256 "8de91a28a9e22941818185380825eacd950d1420b850e82879204c4a3a1d3152" => :el_capitan
    sha256 "9af9e5d0c49ca9307ec41f229cb3fb2b53e7f13cc10b0c033750e7512f3dcf1a" => :yosemite
    sha256 "fcfe6027b7d366f6a2bff783e0ab1e9abfc7c38c1a6fd31fa4a2fb9d325a2819" => :mavericks
  end

  option :universal

  depends_on "xerces-c"

  # Fix segfault. See https://issues.apache.org/jira/browse/XALANC-751
  patch :DATA

  def install
    ENV.deparallelize # See https://issues.apache.org/jira/browse/XALANC-696
    ENV.universal_binary if build.universal?
    ENV["XALANCROOT"] = "#{buildpath}/c"
    ENV["XALAN_LOCALE_SYSTEM"] = "inmem"
    ENV["XALAN_LOCALE"] = "en_US"

    cd "c" do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
      system "make", "install"
      # Clean up links
      rm Dir["#{lib}/*.dylib.*"]
    end
  end

  test do
    (testpath/"input.xml").write <<-EOS.undent
      <?xml version="1.0"?>
      <Article>
        <Title>An XSLT test-case</Title>
        <Authors>
          <Author>Roger Leigh</Author>
          <Author>Open Microscopy Environment</Author>
        </Authors>
        <Body>This example article is used to verify the functionality
        of Xalan-C++ in applying XSLT transforms to XML documents</Body>
      </Article>
    EOS

    (testpath/"transform.xsl").write <<-EOS.undent
      <?xml version="1.0"?>
      <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:output method="text"/>
        <xsl:template match="/">Article: <xsl:value-of select="/Article/Title"/>
      Authors: <xsl:apply-templates select="/Article/Authors/Author"/>
      </xsl:template>
        <xsl:template match="Author">
      * <xsl:value-of select="." />
        </xsl:template>
      </xsl:stylesheet>
    EOS

    assert_match "Article: An XSLT test-case\nAuthors: \n* Roger Leigh\n* Open Microscopy Environment", shell_output("#{bin}/Xalan #{testpath}/input.xml #{testpath}/transform.xsl")
  end
end

__END__
--- a/c/src/xalanc/PlatformSupport/XalanLocator.hpp
+++ b/c/src/xalanc/PlatformSupport/XalanLocator.hpp
@@ -91,7 +91,7 @@ public:
             const XalanDOMChar*     theAlternateId = getEmptyPtr())
     {
         return theLocator == 0 ? theAlternateId : (theLocator->getSystemId() ?
-            theLocator->getPublicId() : theAlternateId);
+            theLocator->getSystemId() : theAlternateId);
     }

     /**
