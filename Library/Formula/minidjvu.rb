require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Minidjvu < Formula
  homepage 'http://minidjvu.sourceforge.net/'
  url 'http://sourceforge.net/projects/minidjvu/files/minidjvu/0.8/minidjvu-0.8.tar.gz'
  md5 'b354eb74d83c6e2d91aab2a6c2879ba7'
  depends_on 'djvulibre'
  depends_on 'libtiff'

  def install
    ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "(cd #{prefix}; mkdir -p lib; mv lib*.dylib lib)"
  end

  def test
    #  minidjvu always errors unless it successfully converts an actual tiff file.
    #  Run the test with `brew test minidjvu`.
    system "ls -l #{bin}/minidjvu"
  end
end
