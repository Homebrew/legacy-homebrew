require 'formula'

class Enscript < Formula
  homepage 'http://www.gnu.org/software/enscript/'
  url 'http://ftpmirror.gnu.org/enscript/enscript-1.6.6.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz'
  sha1 '1f1e97a2ebb3d77f48c57487fe39e64139fb2beb'

  head 'git://git.savannah.gnu.org/enscript.git'

  keg_only :provided_pre_mountain_lion

  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/enscript -V | grep 'GNU Enscript #{version}'"
  end
end
