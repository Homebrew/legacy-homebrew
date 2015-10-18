class Tidyp < Formula
  desc "Validate and modify HTML"
  homepage "http://tidyp.com/"
  url "https://github.com/downloads/petdance/tidyp/tidyp-1.04.tar.gz"
  sha256 "20b0fad32c63575bd4685ed09b8c5ca222bbc7b15284210d4b576d0223f0b338"

  resource "manual" do
    url "https://raw.githubusercontent.com/petdance/tidyp/6a6c85bc9cb089e343337377f76127d01dd39a1c/htmldoc/tidyp1.xsl"
    sha256 "68ea4bb74e0ed203fb2459d46e789b2f94e58dc9a5a6bc6c7eb62b774ac43c98"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Use the newly brewed tidyp to generate the manual
    resource("manual").stage do
      system "#{bin}/tidyp -xml-help > tidyp1.xml"
      system "#{bin}/tidyp -xml-config > tidyp-config.xml"
      system "/usr/bin/xsltproc tidyp1.xsl tidyp1.xml > tidyp.1"
      man1.install gzip("tidyp.1")
    end
  end
end
