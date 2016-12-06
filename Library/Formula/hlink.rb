require 'formula'

class Hlink < Formula
  url 'https://github.com/darwin/hlink/tarball/v0.1'
  homepage 'https://github.com/darwin/hlink'
  md5 '07cc930e783218b96b6c49f82ee8b3ab'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
