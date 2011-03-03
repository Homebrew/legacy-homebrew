require 'formula'

class Znc <Formula
  url 'http://znc.in/releases/archive/znc-0.096.tar.gz'
  md5 '38eec4f1911a68b4d2fc704170e7cbf6'
  homepage 'http://en.znc.in/wiki/ZNC'

  depends_on 'pkg-config' => :build
  depends_on 'c-ares'

  skip_clean 'bin/znc'
  skip_clean 'bin/znc-config'
  skip_clean 'bin/znc-buildmod'

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-extra"
    system "make install"
  end
end
