require 'formula'

class Unrar < Formula
  homepage 'http://www.rarlab.com'
  url 'http://www.rarlab.com/rar/unrarsrc-5.0.13.tar.gz'
  sha1 '411644d3d31fa021163eab66751d4f4fa9bce8c7'

  def install
    system "make"
    bin.install 'unrar'
  end
end
