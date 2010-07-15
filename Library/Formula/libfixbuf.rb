require 'formula'

class Libfixbuf <Formula
  url 'http://tools.netsa.cert.org/releases/libfixbuf-0.8.0.tar.gz'
  homepage 'http://tools.netsa.cert.org/fixbuf/'
  md5 '7c22a5b376a3661c7bb79ca2972c0173'

  depends_on 'glib'

  def install
    system "./configure",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--prefix=#{prefix}",
        "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
