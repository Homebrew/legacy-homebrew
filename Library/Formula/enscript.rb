require 'formula'

class Enscript < Formula
  homepage 'http://www.gnu.org/software/enscript/'
  url 'http://ftpmirror.gnu.org/enscript/enscript-1.6.5.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/enscript/enscript-1.6.5.2.tar.gz'
  sha1 'b6d08e72e8e75e7c8a72c75a55c8de3bdebcf22c'

  head 'git://git.savannah.gnu.org/enscript.git'

  keg_only 'X11/XQuartz provides enscript.' if MacOS::XQuartz.installed?

  depends_on 'gettext'

  def install
    args = %W[
      --prefix=#{prefix}
      --with-libintl-prefix=#{Formula.factory("gettext").prefix}
    ]
    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/enscript -V | grep 'GNU Enscript #{version}'"
  end
end
