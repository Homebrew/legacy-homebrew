require 'formula'

class Jq < Formula
  homepage 'http://stedolan.github.com/jq/'
  url 'https://github.com/stedolan/jq/archive/jq-1.1.tar.gz'
  sha1 '555c9b2d9852376092be556bc0649154d5b5c2bf'
  head 'https://github.com/stedolan/jq.git'

  def install
    system "make"
    bin.install 'jq'
  end
end
