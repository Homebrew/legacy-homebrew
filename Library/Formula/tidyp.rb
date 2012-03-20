require 'formula'

class TidypManual < Formula
  url "https://github.com/petdance/tidyp/raw/6a6c85bc9cb089e343337377f76127d01dd39a1c/htmldoc/tidyp1.xsl"
  md5 "5f90f914e69bdff1663a6772c6d9ca3d"
end

class Tidyp < Formula
  url 'https://github.com/downloads/petdance/tidyp/tidyp-1.04.tar.gz'
  homepage 'http://tidyp.com/'
  md5 '00a6b804f6625221391d010ca37178e1'

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
