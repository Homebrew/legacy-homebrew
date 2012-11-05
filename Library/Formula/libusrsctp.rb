require 'formula'

class Libusrsctp < Formula
  homepage 'http://sctp.fh-muenster.de/sctp-user-land-stack.html'
  url 'http://sctp.fh-muenster.de/download/libusrsctp-0.9.1.tar.gz'
  sha1 'b719ddd754fd21b2bda634db20640bb9477c2a1b'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
