require 'formula'

class Libntlm < Formula
  homepage 'http://www.nongnu.org/libntlm/'
  url 'http://www.nongnu.org/libntlm/releases/libntlm-1.4.tar.gz'
  sha1 'b15c9ccbd3829154647b3f9d6594b1ffe4491b6f'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
