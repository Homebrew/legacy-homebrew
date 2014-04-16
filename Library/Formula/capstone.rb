require 'formula'

class Capstone < Formula
  homepage 'http://capstone-engine.org'
  url 'http://capstone-engine.org/download/2.1.2/capstone-2.1.2.tgz'
  sha1 '235ceab369025fbad9887fe826b741ca84b1ab41'

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
