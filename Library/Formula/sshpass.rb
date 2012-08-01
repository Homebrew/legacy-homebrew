require 'formula'

class Sshpass < Formula
  homepage 'http://sshpass.sourceforge.net/'
  url 'http://sourceforge.net/projects/sshpass/files/sshpass/1.05/sshpass-1.05.tar.gz/download'
  sha1 '6dafec86dd74315913417829542f4023545c8fd7'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "sshpass"
  end
end
