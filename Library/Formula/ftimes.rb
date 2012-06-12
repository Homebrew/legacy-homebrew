require 'formula'

class Ftimes < Formula
  homepage 'http://ftimes.sourceforge.net/FTimes/index.shtml'
  url 'http://downloads.sourceforge.net/project/ftimes/ftimes/3.8.0/ftimes-3.8.0.tgz'
  md5 'b4bc8a3c00b3aed9e9cc9583234ec6a7'

  depends_on 'pcre'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    inreplace 'doc/ftimes/Makefile' do |s|
      s.change_make_var! 'INSTALL_PREFIX', man1
    end

    system "make install"
  end
end
