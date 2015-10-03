class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/unstable/utils/debianutils"
  url "https://mirrors.kernel.org/debian/pool/main/d/debianutils/debianutils_4.5.1.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/debianutils/debianutils_4.5.1.tar.xz"
  sha256 "a531c23e0105fe01cfa928457a8343a1e947e2621b3cd4d05f4e9656020c63b7"

  bottle do
    cellar :any
    sha256 "7423986e33ae722a5180c7a42c22a497e31d5d9ae140612d07dfc4b7f679caaa" => :yosemite
    sha256 "6b7732f38f3654feda464cb57f6ecc901bd765f30682f8e6e1bd7623ee9f2ff0" => :mavericks
    sha256 "36f1cd0ac60602c203bd1b1bac57b6c85991ad54e6f8cf61dae0e2f5541ccc89" => :mountain_lion
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
