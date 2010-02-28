require 'formula'

class TokyoDystopia <Formula
  url 'http://1978th.net/tokyodystopia/tokyodystopia-0.9.13.tar.gz'
  homepage 'http://1978th.net/tokyodystopia/'
  sha1 '073b2edd6a74e2ae1bbdc7faea42a8a219bdf169'

  depends_on 'tokyo-cabinet'

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}", "--includedir=#{include}"
    system "make"
    system "make install"
  end
end
