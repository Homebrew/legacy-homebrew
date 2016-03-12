class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v2.2.tar.gz"
  sha256 "5e0948e775bdfcef1db94a209778a23844a5cef4ef3aa2c12b1dadf75311db7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "073bead051d86b4960bbf867838f4477cc6297c4f7ccd8455e4c37ca28d60250" => :el_capitan
    sha256 "598f00f3c84a61b95ff7c5ca3c7d1da61e7d1534e029049a293b5059c4575f2b" => :yosemite
    sha256 "28e563fb4a51613c1c815dc43c38e9b6f221e2ae53cb42d2e91665eaef7fdec6" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match /Homebrew/, shell_output("PYTHONIOENCODING=utf-8 #{bin}/googler Homebrew </dev/null")
  end
end
