require 'formula'

class TokyoCabinet <Formula
  url 'http://1978th.net/tokyocabinet/tokyocabinet-1.4.45.tar.gz'
  homepage 'http://1978th.net/tokyocabinet/'
  sha1 '71b119818ef04dd97ba06bac27cdafaf6d7cce41'

  def install
    system "./configure", "--prefix=#{prefix}"
                          "--enable-fastest"
    system "make"
    system "make install"
  end
end
