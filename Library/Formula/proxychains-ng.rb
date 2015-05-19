class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https://sourceforge.net/projects/proxychains-ng/"
  url "https://downloads.sourceforge.net/project/proxychains-ng/proxychains-4.8.1.tar.bz2"
  sha256 "7d87643174b66b3dc5085068cd5ec9445d813295d0e430254c8a01acf72e7d1d"

  head "https://github.com/rofl0r/proxychains-ng.git"

  bottle do
    sha256 "92d5f607258590e688f7e34ea3eb1230e41d814f42db52761d10052dd115cb2e" => :yosemite
    sha256 "d1938513e85d32c58370858baf1f867e2616cdbb6031ee3538a61a115416a2d6" => :mavericks
    sha256 "0569c9935b27f10a408e44691f22d344048bf61e924cbeb97f1eaa42c8a594e5" => :mountain_lion
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
