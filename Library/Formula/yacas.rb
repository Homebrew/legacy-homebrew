class Yacas < Formula
  homepage "http://yacas.sourceforge.net"
  url "https://downloads.sourceforge.net/project/yacas/yacas-source/1.3/yacas-1.3.4.tar.gz"
  sha1 "c166fe92eaf3dd4218e4b10ac752457b980ae6e2"

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
