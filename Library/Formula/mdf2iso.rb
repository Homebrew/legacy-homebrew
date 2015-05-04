class Mdf2iso < Formula
  homepage "https://packages.debian.org/sid/mdf2iso"
  url "https://mirrors.kernel.org/debian/pool/main/m/mdf2iso/mdf2iso_0.3.1.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mdf2iso/mdf2iso_0.3.1.orig.tar.gz"
  sha256 "906f0583cb3d36c4d862da23837eebaaaa74033c6b0b6961f2475b946a71feb7"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/mdf2iso --help")
  end
end
