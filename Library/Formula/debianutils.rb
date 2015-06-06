class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/unstable/utils/debianutils"
  url "https://mirrors.kernel.org/debian/pool/main/d/debianutils/debianutils_4.5.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/debianutils/debianutils_4.5.tar.gz"
  sha256 "7cfaa53caaaaf36dad16fa69b30dd2b78b8dafebd766aacd53a3c7c78a9d441f"

  bottle do
    cellar :any
    sha256 "4bb3da90b4acb91ea04834e435d3ce9de9862e98cb0f24460ad0ebbe0422f982" => :yosemite
    sha256 "bc3c45c875cbe12ab481bfe4e9d8c32b8e9d6931cc75f9e9a0d6ab5dae6ebf3c" => :mavericks
    sha256 "32dc195d03d434f94447342ca72655f7c0272c582278015309c7627c97a57b97" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    # some commands are Debian Linux specific and we don't want them, so install specific tools
    bin.install "run-parts", "ischroot", "tempfile"
    man1.install "ischroot.1", "tempfile.1"
    man8.install "run-parts.8"
  end

  test do
    assert File.exist?(shell_output("#{bin}/tempfile -d #{Dir.pwd}").strip)
  end
end
