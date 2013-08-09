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
    # Install manully; we don't install an egg-info
    bin.install 'mkvtomp4'
    man1.install 'doc/mkvtomp4.1'
  end
end
