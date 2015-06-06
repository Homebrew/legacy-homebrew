class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "http://xmlrpc-c.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.33.17/xmlrpc-c-1.33.17.tgz"
  sha256 "50118a3ca1114828f7cae27b7253cc25045849e487f5d0bb91d962777fc05355"

  bottle do
    cellar :any
    sha256 "7957f1242e7556f0dd5a956e826bcfa5fb0c777f7c986b489b44cf65b4def4d9" => :yosemite
    sha256 "357c6f02d5b12ee56518b23cd2c9418d26c6e8097c2e07dd74e90ae42e4d6bf3" => :mavericks
    sha256 "4a51dc5bc81393f1bee7121534c7759b1fa34f4a35a9b42114f3d23153e712d6" => :mountain_lion
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
