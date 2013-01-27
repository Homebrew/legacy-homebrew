require 'formula'

class Axel < Formula
  homepage 'http://freshmeat.net/projects/axel/'
  url 'http://alioth.debian.org/frs/download.php/3016/axel-2.4.tar.bz2'
  sha1 '9e212e2890a678ccb2ab48f575a659a32d07b1a9'

  def install
    system "./configure", "--prefix=#{prefix}", "--debug=0", "--i18n=0"
    system "make"
    system "make install"
  end
end
