require 'formula'

class TokyoCabinet < Formula
  homepage 'http://fallabs.com/tokyocabinet/'
  url 'http://fallabs.com/tokyocabinet/tokyocabinet-1.4.47.tar.gz'
  md5 '3d94fe2aebf5d9ff0478ed895bc46fc9'

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-fastest"
    system "make"
    system "make install"
  end
end
