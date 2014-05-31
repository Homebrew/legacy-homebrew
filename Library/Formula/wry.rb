require "formula"

class Wry < Formula
  homepage "http://grailbox.com/wry/"
  url "https://github.com/hoop33/wry/archive/v1.7.3.tar.gz"
  sha1 "e4fdde7ffcaa2bdaf35a9b9147f8c2da24c65e71"

  head "https://github.com/hoop33/wry.git"

  bottle do
    cellar :any
    sha1 "c8994394b33c6458436cab42dddeb7a7b80b3239" => :mavericks
    sha1 "40f23ed60b0a916ea8caa9ccd5c547897a2ee9d1" => :mountain_lion
    sha1 "a0c072f531078c12b9160b0ab4deefffaed033ac" => :lion
  end

  depends_on :macos => :lion
  depends_on :xcode => :build

  def install
    xcodebuild "-target", "wry", "-configuration", "Release", "SYMROOT=build", "OBJROOT=objroot"
    bin.install "build/Release/wry"
  end
end
