class Quit < Formula
  desc "Command-line tool to politely quit applications"
  homepage "http://www.macupdate.com/app/mac/31821/quit"
  url "http://www.macupdate.com/download/31821/quit.1.9.2.zip"
  sha256 "6d4f41e69d2477cb3d2e7bb51996f0f13ce6edcbf6e86d2c7e64094d2bfd35be"

  def install
    bin.install "quit"
  end

  test do
    system "#{bin}/quit", "-h"
  end
end
