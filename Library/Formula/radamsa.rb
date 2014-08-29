require 'formula'

class Radamsa < Formula
  homepage 'https://code.google.com/p/ouspg/wiki/Radamsa'
  url 'https://ouspg.googlecode.com/files/radamsa-0.3.tar.gz'
  sha1 '94664298b9c5c1563fe4aa7b8fc8530bb6628a51'

  def install
    system "make"
    man1.install "doc/radamsa.1"
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    The Radamsa binary has been installed.
    The Lisp source code has been copied to:
      #{prefix}/rad

    To be able to recompile the source to C, you will need run:
      $ make get-owl

    Tests can be run with:
      $ make .seal-of-quality

    EOS
  end

  test do
    system bin/"radamsa", "-V"
  end
end
