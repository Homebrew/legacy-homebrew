require 'formula'

class Sshpass < Formula
  homepage 'http://sourceforge.net/projects/sshpass/'
  url 'http://downloads.sourceforge.net/project/sshpass/sshpass/1.05/sshpass-1.05.tar.gz'
  sha1 '6dafec86dd74315913417829542f4023545c8fd7'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "bin/sshpass"
  end
end
