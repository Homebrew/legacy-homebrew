class Yacas < Formula
  homepage "http://yacas.sourceforge.net"
  url "https://downloads.sourceforge.net/project/yacas/yacas-source/1.3/yacas-1.3.4.tar.gz"
  sha1 "c166fe92eaf3dd4218e4b10ac752457b980ae6e2"

  bottle do
    sha1 "c79875e27d9797235ef16d977ef846db0e2d6be6" => :yosemite
    sha1 "328cb29c9c442b8fe15c96537fe2ff80fe0ae55e" => :mavericks
    sha1 "c41b7729e1c9d735bac9cbcd927f7fc6ab57a2c4" => :mountain_lion
  end

  option "with-server", "Build the network server version"

  def install
    args = ["--disable-silent-rules",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
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
