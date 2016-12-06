require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Mkvtomp4 < Formula
  homepage 'http://code.google.com/p/mkvtomp4/'
  url 'http://mkvtomp4.googlecode.com/files/mkvtomp4-1.2.tar.bz2'
  md5 '42b26fd263c42cba3de9a7aae07a8476'

  depends_on 'gpac'
  depends_on 'ffmpeg'
  depends_on 'mkvtoolnix'

  def install
    # ENV.x11 # if your formula requires any X11 headers
    # ENV.j1  # if your formula's build system can't parallelize

    system "make"
    system "python setup.py build"
    system "python setup.py install --prefix #{prefix}"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test detail?name=mkvtomp4`.
    system "mkvtomp4"
  end
end
