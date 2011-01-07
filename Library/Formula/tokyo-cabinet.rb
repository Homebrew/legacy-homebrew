require 'formula'

class TokyoCabinet <Formula
  url 'http://fallabs.com/tokyocabinet/tokyocabinet-1.4.46.tar.gz'
  homepage 'http://fallabs.com/tokyocabinet/'
  md5 '341dadd1f3d68760e350f7e731111786'

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-fastest"
    system "make"
    system "make install"
  end
end
