class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "http://xmlrpc-c.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.39.07/xmlrpc-c-1.39.07.tgz"
  sha256 "b79aaa657084e26e7b732502f07b3af68375e37aeb1d1cd577ea3a413d7e1af3"

  bottle do
    cellar :any
    sha256 "bbbdb697490a78b9a83ca9f38f83cb5220c5ddc61a75c419c22f8779f869ec50" => :el_capitan
    sha256 "fa59a570d88523416352a681e09bad49e864c5bf5cf5c7896d179155a7c62f10" => :yosemite
    sha256 "6b6a45b94ccc09e499b2216bf394d3641d01a5974cdf1212c908c26ea903428a" => :mavericks
  end

  def install
    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--enable-libxml2-backend",
                          "--prefix=#{prefix}"

    # xmlrpc-config.h cannot be found if only calling make install
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/xmlrpc-c-config", "--features"
  end
end
