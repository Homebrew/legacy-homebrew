require 'formula'

class Dadadodo < Formula
  homepage 'http://www.jwz.org/dadadodo/'
  url 'http://www.jwz.org/dadadodo/dadadodo-1.04.tar.gz'
  sha1 '20b3c802db70c8c4fddf751e668aa6218c085643'

  def install
    system "make"
    bin.install "dadadodo"    
  end
end
