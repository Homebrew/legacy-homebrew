require "formula"

class Apel < Formula
  homepage "http://git.chise.org/elisp/apel/"
  url "http://git.chise.org/elisp/dist/apel/apel-10.8.tar.gz"
  sha1 "089c18ae006df093aa2edaeb486bfaead6ac4918"

  def install
    system "make"
    system "sudo", "make", "install"
  end

end
