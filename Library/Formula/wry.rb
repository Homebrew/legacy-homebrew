require "formula"

class Wry < Formula
  homepage "http://grailbox.com/wry/"
  url "https://github.com/hoop33/wry/archive/v1.8.2.tar.gz"
  sha1 "eb32f934755992fbd5aafedd37037cba0b73e551"

  head "https://github.com/hoop33/wry.git"

  bottle do
    cellar :any
    sha1 "01ed3904c9e01e700643609efae8fc0d8714bcc2" => :mavericks
    sha1 "436083b0ec2addb57a9f042a8fcf99cbfce19618" => :mountain_lion
    sha1 "1f492a3b41120e67046b84ee9d1d1f25e3897a87" => :lion
  end

  depends_on :macos => :lion
  depends_on :xcode => :build

  def install
    xcodebuild "-target", "wry", "-configuration", "Release", "SYMROOT=build", "OBJROOT=objroot"
    bin.install "build/Release/wry"
  end
end
