class Tccutil < Formula
  desc "Utility to modify the OS X Accessibility Database (TCC.db)"
  homepage "https://github.com/jacobsalmela/tccutil"
  url "https://github.com/jacobsalmela/tccutil/archive/v1.2.1.tar.gz"
  sha256 "7aa4506889db29ae2949f3496d4d649d6de96631a7114eaaa445664367cf288c"
  head "https://github.com/jacobsalmela/tccutil.git"

  bottle :unneeded

  def install
    bin.install "tccutil.py" => "tccutil"
  end

  test do
    system "#{bin}/tccutil", "--help"
  end
end
