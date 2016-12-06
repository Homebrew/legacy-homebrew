require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Darts < Formula
  homepage 'http://chasen.org/~taku/software/darts/'
  url 'http://chasen.org/~taku/software/darts/src/darts-0.32.tar.gz'
  sha1 '14a20a36ded935bef2752a726e027baece7bc801'
  keg_only "The DARTS library is a requirement for chasen"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    system "false"
  end
end
