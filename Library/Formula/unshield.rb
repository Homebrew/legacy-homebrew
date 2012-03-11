require 'formula'

class Unshield < Formula
  homepage 'http://www.synce.org/oldwiki/index.php/Unshield'
  url 'http://downloads.sourceforge.net/project/synce/Unshield/0.6/unshield-0.6.tar.gz'
  md5 '31a829192a255160d1f71cda4c865c9c'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
