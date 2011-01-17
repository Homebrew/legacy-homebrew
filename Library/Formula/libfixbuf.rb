require 'formula'

class Libfixbuf <Formula
  url 'http://tools.netsa.cert.org/releases/libfixbuf-0.9.0.tar.gz'
  homepage 'http://tools.netsa.cert.org/fixbuf/'
  md5 '3687a7a28bc9535544e2fbc1d1383077'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
