require 'formula'

class Unshield < Formula
  homepage 'http://www.synce.org/oldwiki/index.php/Unshield'
  url 'http://downloads.sourceforge.net/project/synce/Unshield/0.6/unshield-0.6.tar.gz'
  sha1 '3e1197116145405f786709608a5a636a19f4f3e1'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
