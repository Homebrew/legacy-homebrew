require 'formula'

class Cvsutils < Formula
  homepage 'http://www.red-bean.com/cvsutils/'
  url 'http://www.red-bean.com/cvsutils/releases/cvsutils-0.2.5.tar.gz'
  sha1 '294599ce431be50ad1da7295e8b6a65a17fbf531'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/cvsu --help"
  end
end
