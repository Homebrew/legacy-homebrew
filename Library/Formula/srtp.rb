require 'formula'

class Srtp < Formula
  homepage 'http://srtp.sourceforge.net/srtp.html'
  url 'https://downloads.sourceforge.net/project/srtp/srtp/1.4.4/srtp-1.4.4.tgz'
  sha1 '299c6cfe0c9d6f1804bc5921cfbdb6a6bc76a521'

  # Add support for building shared libs
  patch do
    url "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/net-libs/libsrtp/files/libsrtp-1.4.4-shared.patch?revision=1.2"
    sha1 "d7871a264dd9fd588fc6d79c15019a1dacd3edbb"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make libsrtp.dylib"
    system "make install" # Can't go in parallel of building the dylib
  end
end
