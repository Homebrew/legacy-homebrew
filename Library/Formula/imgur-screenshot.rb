class ImgurScreenshot < Formula
  desc "Take screenshot selection, upload to imgur. + more cool things"
  homepage "https://github.com/jomo/imgur-screenshot"
  url "https://github.com/jomo/imgur-screenshot/archive/v1.5.4.tar.gz"
  sha256 "147fe1c3b3e407d952fa8abbdb9b436192133cf7a56278edc0dd87c2a9c9c430"
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
