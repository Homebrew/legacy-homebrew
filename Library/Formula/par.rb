require 'formula'

class Par < Formula
  url 'http://www.nicemice.net/par/Par152.tar.gz'
  homepage 'http://www.nicemice.net/par/'
  md5 '4ccacd824171ba2c2f14fb8aba78b9bf'

  def install
    system "make -f protoMakefile"
    bin.install 'par'
  end
end
