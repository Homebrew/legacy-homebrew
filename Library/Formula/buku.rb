class Buku < Formula
  desc "Command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/1.8.tar.gz"
  sha256 "352c95f0ba69864dce37a9010e91fa227b37a072922107ec84246f3c760fa4cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f5b21390a1d814964de1c44d3ec4e653b42080b0738ca00679b219f4e567ef6" => :el_capitan
    sha256 "1e5ac1bf412e66e62d276747a125b99a2ed48e72c494c2dd8ebff979f4f74401" => :yosemite
    sha256 "7749bcbcd7d0330b87bc8ee7c6426cc7c5d724751d12630df73d45f19398138c" => :mavericks
  end

  depends_on :python3

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/buku", "-a", "https://github.com/Homebrew/homebrew"
    assert_match %r{https://github.com/Homebrew/homebrew}, shell_output("#{bin}/buku -s github </dev/null")
  end
end
