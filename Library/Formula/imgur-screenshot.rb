class ImgurScreenshot < Formula
  desc "Take screenshot selection, upload to imgur. + more cool things"
  homepage "https://github.com/jomo/imgur-screenshot"
  url "https://github.com/jomo/imgur-screenshot/archive/v1.6.0.tar.gz"
  sha256 "1050d87dd3a10652f37998d962034fe1b126d460c7d8eb378359879cec647bc1"
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
