require "formula"

class Crunch < Formula
  homepage "http://sourceforge.net/projects/crunch-wordlist"
  url "https://downloads.sourceforge.net/project/crunch-wordlist/crunch-wordlist/crunch-3.6.tgz"
  sha1 "51bdf8b9dfb9e4486fa6a85e0224522569de4557"

  def install
    system "make", "CC=#{ENV.cc}", "LFS=-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"

    bin.install "crunch"
    man1.install "crunch.1"
    share.install Dir["*.lst"]
  end
end
