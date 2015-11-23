class Yacas < Formula
  desc "General purpose computer algebra system"
  homepage "http://yacas.sourceforge.net"
  url "https://downloads.sourceforge.net/project/yacas/yacas-source/1.3/yacas-1.3.4.tar.gz"
  sha256 "18482f22d6a8336e9ebfda3bec045da70db2da68ae02f32987928a3c67284233"

  bottle do
    revision 1
    sha1 "7613703c3bc41a2897e0cf8a70e4210efbbe71ba" => :yosemite
    sha1 "5626da72853a063aaf4f568b62b3c0c3898a3e1b" => :mavericks
    sha1 "81376d90f1e74a797202f214c08e8f8fafae77b2" => :mountain_lion
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
