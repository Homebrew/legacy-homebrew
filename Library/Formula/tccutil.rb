class Tccutil < Formula
  desc "Utility to modify the OS X Accessibility Database (TCC.db)"
  homepage "https://github.com/jacobsalmela/tccutil"
  url "https://github.com/jacobsalmela/tccutil/archive/v1.2.0.tar.gz"
  sha256 "3fcac0c458969629366002a2e0142a7291ab44a0077c5495de4b1383704861bc"
  head "https://github.com/jacobsalmela/tccutil.git"

  bottle :unneeded

  def install
    bin.install "tccutil.py" => "tccutil"
  end

  test do
    system "#{bin}/tccutil", "--help"
  end
end
