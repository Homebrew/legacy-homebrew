class Pmccabe < Formula
  desc "Calculate McCabe-style cyclomatic complexity for C/C++ code"
  homepage "https://packages.debian.org/sid/pmccabe"
  url "https://mirrors.kernel.org/debian/pool/main/p/pmccabe/pmccabe_2.6.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/pmccabe/pmccabe_2.6.tar.gz"
  sha256 "e490fe7c9368fec3613326265dd44563dc47182d142f579a40eca0e5d20a7028"

  bottle do
    cellar :any
    sha256 "babed1092c9b75baf350599cde2359c9a339db8f40a0a88875757a5834ac51a7" => :yosemite
    sha256 "3749503b9a930447c9e2e778205965a6cbcd7987950bd93bc6530646539e7735" => :mavericks
    sha256 "62b9b9309f189d79821368ca2e69912ee33a3fef7a208f57dfdb446e4249f36a" => :mountain_lion
  end

  def install
    ENV.append_to_cflags "-D__unix"

    system "make"
    bin.install "pmccabe", "codechanges", "decomment", "vifn"
    man1.install Dir["*.1"]
  end

  test do
    assert_match /pmccabe #{version}/, shell_output("#{bin}/pmccabe -V")
  end
end
