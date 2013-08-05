require 'formula'

class Mkvtomp4 < Formula
  homepage 'http://code.google.com/p/mkvtomp4/'
  url 'http://mkvtomp4.googlecode.com/files/mkvtomp4-1.2.tar.bz2'
  sha1 '6ffcab3c28ef2e0107defdef4f27d3c5d7292023'

  depends_on 'gpac'
  depends_on 'ffmpeg'
  depends_on 'mkvtoolnix'
  depends_on :python

  def install
    system "make"
    system python, "setup.py", "build"
    system python, "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    system "mkvtomp4"
  end
end
