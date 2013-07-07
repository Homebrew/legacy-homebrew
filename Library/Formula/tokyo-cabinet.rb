require 'formula'

class TokyoCabinet < Formula
  homepage 'http://fallabs.com/tokyocabinet/'
  url 'http://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz'
  sha256 'a003f47c39a91e22d76bc4fe68b9b3de0f38851b160bbb1ca07a4f6441de1f90'

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-fastest"
    system "make"
    system "make install"
  end
end
