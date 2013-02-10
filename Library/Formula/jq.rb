require 'formula'

class Jq < Formula
  homepage 'http://stedolan.github.com/jq/'
  url 'https://github.com/stedolan/jq/archive/jq-1.2.tar.gz'
  sha1 '22344795f7b5c06dfacc8f2bc17f95e93c6ff4c3'
  head 'https://github.com/stedolan/jq.git'

  depends_on 'bison'

  def install
    system "make"
    bin.install 'jq'
  end
end
