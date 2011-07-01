require 'formula'

class Unshield < Formula
  url 'http://downloads.sourceforge.net/project/synce/Unshield/0.6/unshield-0.6.tar.gz'
  homepage 'http://www.synce.org/oldwiki/index.php/Unshield'
  md5 '31a829192a255160d1f71cda4c865c9c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
