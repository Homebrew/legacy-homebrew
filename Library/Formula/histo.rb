require 'formula'

class Histo < Formula
  homepage 'https://github.com/visionmedia/histo'
  url 'https://github.com/visionmedia/histo/archive/0.0.1.tar.gz'
  sha1 '2ff59e0be4e4cfca592041c40812a3336b6baa2b'

  def install
    system "make install"
  end

  def test
    system "histo --help"
  end
end
