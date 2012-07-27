require 'formula'

class Aacgain < Formula
  homepage 'http://aacgain.altosdesign.com/'
  url 'http://aacgain.altosdesign.com/alvarez/aacgain-1.9.tar.bz2'
  sha1 '331039c4231e4d85ae878795ce3095dd96dcbfdb'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
