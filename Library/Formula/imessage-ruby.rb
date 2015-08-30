class ImessageRuby < Formula
  desc "Command-line tool to send iMessage"
  homepage "https://github.com/linjunpop/imessage"
  url "https://github.com/linjunpop/imessage/archive/v0.3.1.tar.gz"
  sha256 "74ccd560dec09dcf0de28cd04fc4d512812c3348fc5618cbb73b6b36c43e14ef"
  head "https://github.com/linjunpop/imessage.git"

  bottle do
    cellar :any
    sha256 "ea733fabe5eb0fa1800ec04070586edd6f77de13b22f48064de08d8e8c1b4bd0" => :yosemite
    sha256 "b88419c5ee493a9d96bde86a81ec88866315f41ab91f19eef0402eeab5491d08" => :mavericks
  end

  depends_on :macos => :mavericks

  def install
    rake "standalone:install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/imessage", "--version"
  end
end
