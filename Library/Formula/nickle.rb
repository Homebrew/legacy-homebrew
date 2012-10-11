require 'formula'

class Nickle < Formula
  homepage 'http://www.nickle.org/'
  url 'http://www.nickle.org/release/nickle-2.72.tar.gz'
  sha1 '2acc18e2ed96604876dbabede1ba76e43780ca37'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
