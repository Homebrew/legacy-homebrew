require 'formula'

class Sshpass < Formula
  homepage 'http://sshpass.sourceforge.net/'
  url 'http://hivelocity.dl.sourceforge.net/project/sshpass/sshpass/1.05/sshpass-1.05.tar.gz'
  sha1 '6dafec86dd74315913417829542f4023545c8fd7'

  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end
end
