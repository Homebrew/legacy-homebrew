class ImessageRuby < Formula
  desc "Command-line tool to send iMessage"
  homepage "https://github.com/linjunpop/imessage"
  url "https://github.com/linjunpop/imessage/archive/v0.2.0.tar.gz"
  sha256 "5d67df55a53d0fa657ea439c240a3b322dd0b83a102fa881915569f44431eb00"
  head "https://github.com/linjunpop/imessage.git"

  depends_on :macos => :mavericks

  def install
    rake "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/imessage", "--version"
  end
end
