class Clpbar < Formula
  desc "Command-line progress bar"
  homepage "http://clpbar.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/clpbar/clpbar/bar-1.11.1/bar_1.11.1.tar.gz"
  sha256 "fa0f5ec5c8400316c2f4debdc6cdcb80e186e668c2e4471df4fec7bfcd626503"

  bottle do
    cellar :any_skip_relocation
    sha256 "b54fa0ce24de6dda141e3fc025b67f2e0216b01a3664ec5992a98f8087881ddd" => :el_capitan
    sha256 "edaa21e4d80bbf174e3c040d3c786eb48e381ca8e9477dfbafb06b4ec0bfd19f" => :yosemite
    sha256 "36f1ece44bec7c54d2235fbfba5122d3a3d0430532498dc5c35601a59f9c4616" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--program-prefix='clp'"
    system "make", "install"
  end

  test do
    output = shell_output("dd if=/dev/zero bs=1024 count=5 | #{bin}/clpbar 2>&1")
    assert_match "Copied: 5120B (5.0KB)", output
  end
end
