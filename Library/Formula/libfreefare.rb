require 'formula'

class Libfreefare < Formula
  url 'http://nfc-tools.googlecode.com/files/libfreefare-0.3.2.tar.gz'
  homepage 'http://code.google.com/p/nfc-tools/'
  md5 '88949547cc58f2d30e005ab9bb30b48c'
  head 'http://nfc-tools.googlecode.com/svn/trunk/libfreefare', :using => :svn

  depends_on 'libnfc'

  def install
    if ARGV.build_head?
      ENV['ACLOCAL'] = "/usr/bin/aclocal -I m4 -I #{HOMEBREW_PREFIX}/share/aclocal"

      system "autoreconf -vis"
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
