class UcspiTcp < Formula
  desc "Tools for building TCP client-server applications"
  homepage "https://cr.yp.to/ucspi-tcp.html"
  url "https://cr.yp.to/ucspi-tcp/ucspi-tcp-0.88.tar.gz"
  sha256 "4a0615cab74886f5b4f7e8fd32933a07b955536a3476d74ea087a3ea66a23e9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a57368e57812063bc4e1450c0bef5cad8392c44e54abf3c8ca950ea51abe7ae9" => :el_capitan
    sha256 "727e93394b415da772b43ce5028ad54dcb569f695e6c8c4cdf05dc462b2febbe" => :yosemite
    sha256 "67eb31db588a2299c5e69a4a60f3c56d07624a58e52e77cff2e58be554085d9f" => :mavericks
  end

  patch do
    url "https://www.fefe.de/ucspi/ucspi-tcp-0.88-ipv6.diff19.bz2"
    sha256 "35952cd290d714452c840580126004cbae8db65b1632df67ac9c8fad7d1f9ace"
  end

  def install
    (buildpath/"conf-home").unlink
    (buildpath/"conf-home").write prefix

    system "make"
    bin.mkpath
    system "make", "setup", "check"
    share.install prefix/"man"
  end

  test do
    assert_match(/usage: tcpserver/,
      shell_output("#{bin}/tcpserver 2>&1", 100))
  end
end
