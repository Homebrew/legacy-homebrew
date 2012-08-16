require 'formula'

class Enscript < Formula
  homepage 'http://www.gnu.org/software/enscript/'
  url 'http://ftpmirror.gnu.org/enscript/enscript-1.6.5.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/enscript/enscript-1.6.5.2.tar.gz'
  sha1 'b6d08e72e8e75e7c8a72c75a55c8de3bdebcf22c'

  head 'git://git.savannah.gnu.org/enscript.git'

  keg_only 'Lion and below provide enscript' unless MacOS::mountain_lion_or_newer?

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
