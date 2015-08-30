class ImessageRuby < Formula
  desc "Command-line tool to send iMessage"
  homepage "https://github.com/linjunpop/imessage"
  url "https://github.com/linjunpop/imessage/archive/v0.3.1.tar.gz"
  sha256 "74ccd560dec09dcf0de28cd04fc4d512812c3348fc5618cbb73b6b36c43e14ef"
  head "https://github.com/linjunpop/imessage.git"

  bottle do
    cellar :any
    sha256 "1024e6cee26ed9fc8ae4ef1941edc64d0e6d16006bd2a530d5644e7c00f8a350" => :yosemite
    sha256 "7b546ccf5cf13a7d474c635a57eebc8e74ff61ea6c7c3cdfefffe4c78737ab47" => :mavericks
  end

  depends_on :macos => :mavericks

  def install
    rake "standalone:install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/imessage", "--version"
  end
end
