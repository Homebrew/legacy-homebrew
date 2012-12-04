require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Yersinia < Formula
  homepage 'http://www.yersinia.net'
  url 'http://www.yersinia.net/download/yersinia-0.7.tar.gz'
  version '0.7'
  sha1 'ea8531d7d1fae119324e257cf33f137da8188811'

  # depends_on 'cmake' => :build
  #depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on 'libnet'
  depends_on 'libpcap'  

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--with-libnet-includes=/usr/local/include/", "--disable-gtk", "--with-pcap-includes=/usr/local/include",
                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test yersinia`.
    system "false"
  end
end
