require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Libmodbus < Formula
  homepage 'http://libmodbus.org'
  url 'https://github.com/downloads/stephane/libmodbus/libmodbus-3.0.3.tar.gz'
  sha1 '28f7dcd418181306dd9e3fc1d409b8e0e963c233'

  def install

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test libmodbus`.
    system "false"
  end
end
