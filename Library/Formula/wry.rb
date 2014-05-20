require "formula"

class Wry < Formula
  homepage "http://grailbox.com/wry/"
  url "https://github.com/hoop33/wry/archive/v1.7.3.tar.gz"
  sha1 "e4fdde7ffcaa2bdaf35a9b9147f8c2da24c65e71"

  head "https://github.com/hoop33/wry.git"

  depends_on :macos => :lion
  depends_on :xcode

  def install
    xcodebuild "-target", "wry", "-configuration", "Release", "SYMROOT=build", "OBJROOT=objroot"
    bin.install "build/Release/wry"
  end
end
