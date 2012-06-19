require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Vifm < Formula
  homepage 'http://vifm.sourceforge.net/index.html'
  url 'http://sourceforge.net/projects/vifm/files/vifm-0.7.2.tar.bz2'
  md5 'b95229d69efd66ac1e148b1a454f1c97'

  depends_on 'ncursesw'

  def install
    # ENV.x11 # if your formula requires any X11 headers
    # ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test vifm`.
    system "false"
  end
end
