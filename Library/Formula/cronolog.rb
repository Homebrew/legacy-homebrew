require 'formula'

class Cronolog < Formula
  url 'http://cronolog.org/download/cronolog-1.6.2.tar.gz'
  homepage 'http://cronolog.org/'
  sha1 '6422b7c5e87241eb31d76809a2e0eea77ae4c64e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
