require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Ecore < Formula
  homepage 'http://docs.enlightenment.org/auto/ecore'
  url 'http://download.enlightenment.org/releases/ecore-1.7.0.tar.bz2'
  sha1 '352644e61fd3f71e3af199bb298ed3a30fe8ae11'

  head 'http://svn.enlightenment.org/svn/e/trunk/ecore/'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'eina'
  depends_on 'evas'
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on :libtool

  depends_on 'pkg-config' => :build
 
  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
    			  "--disable-ecore-imf",
			  "--enable-ecore-evas"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test ecore`.
    system "false"
  end
end
