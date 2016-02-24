class Zzz < Formula
  desc "Command-line tool to put Macs to sleep"
  homepage "https://github.com/Orc/Zzz"
  url "https://github.com/Orc/Zzz/archive/v1.tar.gz"
  sha256 "8c8958b65a74ab1081ce1a950af6d360166828bdb383d71cc8fe37ddb1702576"

  head "https://github.com/Orc/Zzz.git"

  bottle :unneeded

  # No test is possible: this has no --help or --version, it just
  # sleeps the Mac instantly.
  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    File.exist? "#{bin}/Zzz"
  end
end
