require 'formula'

class Pwman < Formula
  homepage 'http://pwman.sourceforge.net'
  url 'http://sourceforge.net/projects/pwman/files/pwman/pwman-0.4.4/pwman-0.4.4.tar.gz'
  sha1 '3eb443858de5dbed10a642323ac7b1a27d2b5e08'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    system "pwman"
  end
end
