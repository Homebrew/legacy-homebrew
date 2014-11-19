require 'formula'

class Capstone < Formula
  homepage 'http://capstone-engine.org'
  url 'http://capstone-engine.org/download/3.0/capstone-3.0.tgz'
  sha1 '26e591b8323ed3f6e92637d7ee953cb505687efa'

  bottle do
    cellar :any
    sha1 "939e0cc64db9f03b5cbbe2240e02aa345367d3d8" => :mavericks
    sha1 "9104b5cbe4edce547023b27e22043fe233e3802d" => :mountain_lion
    sha1 "aad566084e5c4bf5923564cb29a46c983191df29" => :lion
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["HOMEBREW_CAPSTONE"] = "1"
    system "./make.sh"
    system "./make.sh", "install"
  end
end
