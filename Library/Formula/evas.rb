require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Evas < Formula
  homepage 'http://docs.enlightenment.org/auto/evas/'
  url 'http://download.enlightenment.org/releases/evas-1.7.5.tar.bz2'
  sha1 '87db3057ff07c350478b7c62d87e347af1671bd4'

  head 'http://svn.enlightenment.org/svn/e/trunk/evas/'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'eina'
  depends_on 'eet'
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on 'jpeg' # this is actually optional, but the packager wants it
  depends_on 'libpng' # this is actually optional, but the packager wants it
  depends_on 'librsvg' # this is actually optional, but the packager wants it

  depends_on 'pkg-config' => :build

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test evas`.
    system "false"
  end
end
