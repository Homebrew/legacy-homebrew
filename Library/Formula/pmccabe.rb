class Pmccabe < Formula
  homepage "https://packages.debian.org/sid/pmccabe"
  url "https://mirrors.kernel.org/debian/pool/main/p/pmccabe/pmccabe_2.6.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/pmccabe/pmccabe_2.6.tar.gz"
  sha256 "e490fe7c9368fec3613326265dd44563dc47182d142f579a40eca0e5d20a7028"

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
