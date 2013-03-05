require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Libint < Formula
  homepage ''
  url 'http://downloads.sourceforge.net/project/libint/libint-for-mpqc/libint-2.0.0-stable.tgz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Flibint%2Ffiles%2F&ts=1362515707&use_mirror=superb-dca3'
  sha1 'b658778f8c9d0be42e2663abb1e40a49d3f2dd30'

  # depends_on 'cmake' => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test libint`.
    system "false"
  end
end
