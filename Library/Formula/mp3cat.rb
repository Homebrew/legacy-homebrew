require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Mp3cat < Formula
  homepage 'http://tomclegg.net/mp3cat'
  url 'http://tomclegg.net/software/mp3cat-0.4.tar.gz'
  md5 '0aa75af15c57b13aa7858092b79f3a61'

  #depends_on 'cmake' => :build

  def install
    # ENV.x11 # if your formula requires any X11 headers
    # ENV.j1  # if your formula's build system can't parallelize

    #system "./configure", "--disable-debug", "--disable-dependency-tracking",
    #                      "--prefix=#{prefix}"
    #system "cmake . #{std_cmake_parameters}"
    system "make"
	bin.install('mp3cat')
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test mp3cat`.
    system "false"
  end
end
