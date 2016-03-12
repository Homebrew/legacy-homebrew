class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v2.2.tar.gz"
  sha256 "5e0948e775bdfcef1db94a209778a23844a5cef4ef3aa2c12b1dadf75311db7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "e80627b38cfd099190cc1af1046ff1ac68db9440647cad5861e678ddc73306bc" => :el_capitan
    sha256 "73ed00aa66144356692d90992b5686aaee90356e0ec687b59a4260e53e59e027" => :yosemite
    sha256 "c6414018bf2fa23c50e3e7fb76cfa81580f338dad9388fb18b84f586788cbf7c" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match /Homebrew/, shell_output("PYTHONIOENCODING=utf-8 #{bin}/googler Homebrew </dev/null")
  end
end
