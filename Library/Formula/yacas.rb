class Yacas < Formula
  desc "General purpose computer algebra system"
  homepage "http://yacas.sourceforge.net"
  url "https://downloads.sourceforge.net/project/yacas/yacas-source/1.3/yacas-1.3.4.tar.gz"
  sha256 "18482f22d6a8336e9ebfda3bec045da70db2da68ae02f32987928a3c67284233"

  bottle do
    revision 1
    sha256 "700fa65e0279625861a0f7166c3e213c807ed7ea46b5f10d5ba6be920aa76a64" => :el_capitan
    sha256 "c143a1764ec3dd64563e78e75c09b11d519124a10c97614bd5c6fbc99bab058b" => :yosemite
    sha256 "52c5071ec1f10c3181d11be1cd54d345fef5cdcbd4dcd6ef1d2cd71a8cff1d85" => :mavericks
    sha256 "c3fb8303de3f7e455047994b26b0cb7edbdee3c466eb77e22a66c42746ea766e" => :mountain_lion
  end

  option "with-server", "Build the network server version"

  def install
    args = ["--disable-silent-rules",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"
           ]

    args << "--enable-server" if build.with? "server"

    system "./configure", *args
    system "make", "install"
    system "make", "test"
  end

  test do
    system "#{bin}/yacas", "--version"
  end
end
