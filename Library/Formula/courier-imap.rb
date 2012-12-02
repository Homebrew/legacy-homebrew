require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class CourierImap < Formula
  homepage 'http://www.courier-mta.org/'
  url 'http://downloads.sourceforge.net/project/courier/imap/4.11.0/courier-imap-4.11.0.tar.bz2?r=http%3A%2F%2Fwww.courier-mta.org%2Fdownload.php&ts=1354391676&use_mirror=garr'
  md5 '6aa9a3487e1c255d1826833af362d1f7'

  # depends_on 'cmake' => :build

  def install
    # ENV.x11 # if your formula requires any X11 headers
    # ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install" # if this fails, try separate make/make install steps
    system "make install-configure"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test courier`.
    system "false"
  end
end
