require 'formula'

class TidypManual < Formula
    head "https://github.com/petdance/tidyp/raw/master/htmldoc/tidyp1.xsl"
end

class Tidyp < Formula
  url 'http://github.com/downloads/petdance/tidyp/tidyp-1.04.tar.gz'
  homepage 'http://tidyp.com/'
  md5 '00a6b804f6625221391d010ca37178e1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    TidypManual.new.brew {
        system "#{bin}/tidyp -xml-help > tidyp1.xml"
        system "#{bin}/tidyp -xml-config > tidyp-config.xml"
        system "/usr/bin/xsltproc tidyp1.xsl tidyp1.xml |/usr/bin/gzip >tidyp.1.gz"
        man1.install 'tidyp.1.gz'
    }

  end
end
