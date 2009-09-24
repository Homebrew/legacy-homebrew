require 'brewkit'

class TokyoCabinet <Formula
  @url='http://1978th.net/tokyocabinet/tokyocabinet-1.4.33.tar.gz'
  @homepage='http://1978th.net/tokyocabinet'
  @sha1='c3ded8ee0bde93f072b9436a6244dc7690abd5c6'

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-fastest"
    system "make"
    system "make install"
  end
end
