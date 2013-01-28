require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Emotion < Formula
  homepage 'http://docs.enlightenment.org/auto/emotion/'
  url 'http://download.enlightenment.org/releases/emotion-1.7.5.tar.bz2'
  sha1 '99739e7865e5fc217162f1ae70770af62af09c6b'

  head 'http://svn.enlightenment.org/svn/e/trunk/emotion/'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'eina'
  depends_on 'ecore'
  depends_on 'evas'
  depends_on 'edje'
  depends_on 'gstreamer'

  depends_on 'pkg-config' => :build

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test emotion`.
    system "false"
  end
end
