require 'formula'

class Ftimes < Formula
  homepage 'http://ftimes.sourceforge.net/FTimes/index.shtml'
  url 'https://downloads.sourceforge.net/project/ftimes/ftimes/3.10.0/ftimes-3.10.0.tgz'
  sha1 '96a59d7524d6b2013d0dc42c91e3e5a420667398'

  depends_on 'pcre'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-pcre=#{Formula['pcre'].opt_prefix}",
                          "--prefix=#{prefix}"

    inreplace 'doc/ftimes/Makefile' do |s|
      s.change_make_var! 'INSTALL_PREFIX', man1
    end

    system "make install"
  end
end
