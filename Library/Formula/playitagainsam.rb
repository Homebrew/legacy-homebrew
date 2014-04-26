require "formula"
class Playitagainsam < Formula
  homepage "https://github.com/rfk/playitagainsam"
  url "https://github.com/rfk/playitagainsam/archive/master.tar.gz"
  sha1 "89ae9fd9f91bb90a591d027ee89b9198dc18fe30"
  version "0.3.0"

  def install

    system "python", "setup.py", "install"
  end

  test do
    system "false"
  end
end
