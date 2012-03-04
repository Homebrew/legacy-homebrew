require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Lifelines < Formula
  homepage 'http://lifelines.sourceforge.net/'
  url 'http://sourceforge.net/projects/lifelines/files/lifelines/3.0.62/lifelines-3.0.62.tar.gz'
  md5 'ff617e64205763c239b0805d8bbe19fe'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test lifelines`.
    system "llines --help"
  end
end
