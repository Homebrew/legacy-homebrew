class ImgurScreenshot < Formula
  desc "Take screenshot selection, upload to imgur. + more cool things"
  homepage "https://github.com/jomo/imgur-screenshot"
  url "https://github.com/jomo/imgur-screenshot/archive/v1.7.0.tar.gz"
  sha256 "ddfd9cb1eef6880f9a5cdff09c6f0e5d6e687a0716128758b1f23457c014fec6"
  head "https://github.com/jomo/imgur-screenshot.git"

  bottle :unneeded

  option "with-terminal-notifier", "Needed for Mac OS X Notifications"

  depends_on "terminal-notifier" => :optional

  def install
    bin.install "imgur-screenshot.sh"
  end

  test do
    system "#{bin}/imgur-screenshot.sh", "--check" # checks deps
  end
end
