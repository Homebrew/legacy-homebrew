require 'formula'

class Unrar < Formula
  homepage 'http://www.rarlab.com'
  url 'http://www.rarlab.com/rar/unrarsrc-5.0.12.tar.gz'
  sha1 '03d61213ff810650fc06113ffe153712176af4dd'

  def install
    system "make"
    bin.install 'unrar'
  end
end
