require 'formula'

class Blueutil < Formula
  homepage 'https://github.com/toy/blueutil'
  url 'https://github.com/toy/blueutil/archive/v1.0.0.tar.gz'
  sha1 'b1cce64f7fa87eb0cfa32ef8e1dfc1aa06dbbd98'

  head 'https://github.com/toy/blueutil.git'

  bottle do
    cellar :any
    sha1 "b28c95c99e71944e7e3027c124715eeda0558759" => :mavericks
    sha1 "2d0b35b8b9bfab35d0a2c1dc3f7fdece65471b11" => :mountain_lion
    sha1 "409af2fed8bd34eb070c89ea763039373ace8197" => :lion
  end

  depends_on :xcode => :build

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    xcodebuild 'SDKROOT=', 'SYMROOT=build'
    bin.install 'build/Release/blueutil'
  end
end
