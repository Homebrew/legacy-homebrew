require 'formula'

class Capstone < Formula
  homepage 'http://capstone-engine.org'
  url 'http://capstone-engine.org/download/3.0/capstone-3.0-rc3.tgz'
  sha1 '3382ecd50618deed4d28aff89f66387e86d3ea9b'

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
