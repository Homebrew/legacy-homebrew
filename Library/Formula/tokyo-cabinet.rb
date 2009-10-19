require 'formula'

class TokyoCabinet <Formula
  url 'http://1978th.net/tokyocabinet/tokyocabinet-1.4.35.tar.gz'
  homepage 'http://1978th.net/tokyocabinet'
  sha1 '3c97e96d3b304121ec0d4eaf5000bf6cc6b727e6'

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-fastest",
            "--libdir=#{lib}", "--includedir=#{include}"
    system "make"
    system "make install"
  end
end
