require 'formula'

class Gaffitter < Formula
  homepage 'http://gaffitter.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/gaffitter/gaffitter/0.6.0/gaffitter-0.6.0.tar.bz2'
  sha1 '3e530684e429cd269db5e4481d90c4f22085fb31'

  def install
    system "make"
    bin.install "src/gaffitter"
  end
end
