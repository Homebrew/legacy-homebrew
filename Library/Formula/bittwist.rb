require "formula"

class Bittwist < Formula
  homepage "http://sourceforge.net/projects/bittwist/"
  url "http://downloads.sourceforge.net/project/bittwist/Mac%20OS%20X/Bit-Twist%202.0/bittwist-macosx-2.0.tar.gz"
  sha1 "fcc652f838858edbf86546af945a71b815cf4d6b"

  def install
    system "make"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test bittwist-macosx`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/bittwist", "--help"
    system "#{bin}bittwiste", "--help"
  end
end
