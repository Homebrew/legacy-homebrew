require 'formula'

class Tidyp < Formula
  url 'http://github.com/downloads/petdance/tidyp/tidyp-1.04.tar.gz'
  homepage 'http://tidyp.com/'
  md5 '00a6b804f6625221391d010ca37178e1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
