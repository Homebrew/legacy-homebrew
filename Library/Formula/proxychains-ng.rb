class ProxychainsNg < Formula
  homepage "https://sourceforge.net/projects/proxychains-ng/"
  url "https://downloads.sourceforge.net/project/proxychains-ng/proxychains-4.8.1.tar.bz2"
  sha256 "7d87643174b66b3dc5085068cd5ec9445d813295d0e430254c8a01acf72e7d1d"

  head "https://github.com/rofl0r/proxychains-ng.git"

  bottle do
    sha1 "2dec4dda5f1ee8656133141ee50a0a1bcf616c7d" => :mavericks
    sha1 "ff402165a6ad4edde426615ef64513f0bb3ce92a" => :mountain_lion
    sha1 "5f26998480a6c040cf016f0c1521299c052c24b3" => :lion
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
