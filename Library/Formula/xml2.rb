require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Xml2 < Formula
  homepage 'http://ofb.net/~egnor/xml2/'
  url 'http://download.ofb.net/gale/xml2-0.5.tar.gz'
  sha1 'e954311383d053747ae0c224b12dfddb8a1c0e74'

  # depends_on 'cmake' => :build
  # depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on 'libxml++'
  depends_on 'gcc49' => :build
  depends_on 'pkg-config'

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    # Remove unrecognized options if warned by configure
    system "./configure", "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test xml2`.
    system "echo '<test/>' | xml2"
  end
end
