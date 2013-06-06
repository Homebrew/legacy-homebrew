require 'formula'

class Jq < Formula
  homepage 'http://stedolan.github.io/jq/'
  url 'http://stedolan.github.io/jq/download/source/jq-1.3.tar.gz'
  sha1 'ac1f19e5d9921683af25251e97c2c4bfee895ca2'

  head 'https://github.com/stedolan/jq.git'

  def install
    system "./configure"
    system "make"
    bin.install 'jq'
    man1.install 'jq.1'
  end
end
