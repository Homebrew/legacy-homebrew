require 'formula'

class Yacas < Formula
  homepage 'http://yacas.sourceforge.net'
  url 'http://yacas.sourceforge.net/backups/yacas-1.3.4.tar.gz'
  sha1 'b0918e7f1e697fde48f09055528dacbf7513b931'

  option "with-server", "Build the network server version"

  def install
    args = [ "--disable-silent-rules",
             "--disable-dependency-tracking",
             "--prefix=#{prefix}"
    ]

    args << "--enable-server" if build.with? "server"

    system "./configure", *args
    system "make", "install"
    system "make", "test"
  end
end
