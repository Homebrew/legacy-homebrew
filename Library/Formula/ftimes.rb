require 'formula'

class Ftimes < Formula
  homepage 'http://ftimes.sourceforge.net/FTimes/index.shtml'
  url 'http://sourceforge.net/projects/ftimes/files/ftimes/3.9.0/ftimes-3.9.0.tgz'
  sha1 '2bd1f31d5297730bfcd045f3d645702ef328a403'

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
