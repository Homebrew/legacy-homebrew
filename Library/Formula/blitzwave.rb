require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Blitzwave < Formula
  homepage 'http://oschulz.github.io/blitzwave'
  url 'https://github.com/downloads/oschulz/blitzwave/blitzwave-0.7.1.tar.gz'
  sha1 '2a53f1a9b7967897415afce256f02693a35f380e'

  depends_on 'blitz'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test blitzwave`.
    system "false"
  end
end
