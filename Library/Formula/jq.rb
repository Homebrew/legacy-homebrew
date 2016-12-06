require 'formula'

class Jq < Formula
  homepage 'http://stedolan.github.com/jq/'
  url 'https://github.com/stedolan/jq/tarball/jq-1.1'
  sha1 'a0b170faae0e79c2fcd3a9117ae109572cb9f443'
  head 'https://github.com/stedolan/jq.git'

  def install
    system "make"
    bin.install 'jq'
  end

end
