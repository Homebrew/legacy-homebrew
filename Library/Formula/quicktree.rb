require 'formula'

class Quicktree < Formula
  url 'ftp://ftp.sanger.ac.uk/pub4/resources/software/quicktree/quicktree.tar.gz'
  version '1.1'
  homepage 'http://www.sanger.ac.uk/resources/software/quicktree/'
  sha1 '9924d51801149d59fd90f704aa7e5802f7b1ef31'

  def install
    system "make"
    bin.install "bin/quicktree"
  end
end
