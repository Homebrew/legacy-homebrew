require 'formula'

class Zopfli < Formula
  homepage 'http://googledevelopers.blogspot.com/2013/02/compress-data-more-densely-with-zopfli.html'
  version "0.1"
  head 'https://code.google.com/p/zopfli/', :using => :git



  def install
    system "make"
    system "chmod +x zopfli"
    bin.install "zopfli"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test zopfli`.
    system "zopfli"
  end
end
