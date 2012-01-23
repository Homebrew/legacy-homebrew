require 'formula'

class Orc < Formula
  homepage 'http://code.entropywave.com/projects/orc/'
  url 'http://code.entropywave.com/download/orc/orc-0.4.16.tar.gz'
  md5 'e482932e544c847761449b106ecbc483'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtk-doc"
    system "make install"
  end
end
