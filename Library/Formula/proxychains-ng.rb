class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https://sourceforge.net/projects/proxychains-ng/"
  url "https://downloads.sourceforge.net/project/proxychains-ng/proxychains-4.10.tar.bz2"
  sha256 "3784eef241f022a68a1a0c41a0c225f6edcf4c3ce3bee1cea99ba342084e1f8a"

  head "https://github.com/rofl0r/proxychains-ng.git"

  bottle do
    sha256 "dc6af4fa724352b42370b04e9c15cb2071436a0381d36c90a82173f930309112" => :el_capitan
    sha256 "2bfb53e389b9a3222fb50632e72b7da85262ff9abf69bb477355fff55661c51b" => :yosemite
    sha256 "5f88b3f9d16fd08c182b0c8c9490dc6328e84e597c9ccc2d80fe44fc252512ae" => :mavericks
    sha256 "ec8067e606f210e88b501a8e3e8951a1f7082fb8f86356d1179ec791c02aa621" => :mountain_lion
  end

  option :universal

  def install
    args = ["--prefix=#{prefix}", "--sysconfdir=#{prefix}/etc"]
    if build.universal?
      ENV.universal_binary
      args << "--fat-binary"
    end
    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "install-config"
  end

  test do
    assert_match "config file found", shell_output("#{bin}/proxychains4 test 2>&1", 1)
  end
end
