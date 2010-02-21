require 'formula'

class TokyoCabinet <Formula
  url 'http://1978th.net/tokyocabinet/tokyocabinet-1.4.42.tar.gz'
  homepage 'http://1978th.net/tokyocabinet'
  sha1 'e46da0ef614f821b57564639cf15388df1c39fb5'

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-fastest",
            "--libdir=#{lib}", "--includedir=#{include}"
    system "make"
    system "make install"
  end
end
