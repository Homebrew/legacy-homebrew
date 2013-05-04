require 'formula'

class TidypManual < Formula
  url "https://github.com/petdance/tidyp/raw/6a6c85bc9cb089e343337377f76127d01dd39a1c/htmldoc/tidyp1.xsl"
  sha1 'db6b733bb8e341eb806bc7487faee69eb429a68d'
end

class Tidyp < Formula
  homepage 'http://tidyp.com/'
  url 'https://github.com/downloads/petdance/tidyp/tidyp-1.04.tar.gz'
  sha1 '5d9050512259c3a67a2f48469555932e3a7b8bd0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # Use the newly brewed Tidyp to generate the manual
    TidypManual.new.brew do
      system "#{bin}/tidyp -xml-help > tidyp1.xml"
      system "#{bin}/tidyp -xml-config > tidyp-config.xml"
      system "/usr/bin/xsltproc tidyp1.xsl tidyp1.xml |/usr/bin/gzip >tidyp.1.gz"
      man1.install 'tidyp.1.gz'
    end
  end
end
