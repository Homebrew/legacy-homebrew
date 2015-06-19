require 'formula'

class Compface < Formula
  desc "Convert to and from the X-Face format"
  homepage 'http://freecode.com/projects/compface'
  url 'http://ftp.xemacs.org/pub/xemacs/aux/compface-1.5.2.tar.gz'
  sha1 '72dad8774b3301a1562bdbd5b3c5536ebf86a03d'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    system "make", "install"
  end

  test do
    system bin/"uncompface"
  end
end
