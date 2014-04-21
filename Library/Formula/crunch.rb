require 'formula'

class Crunch < Formula
  homepage 'http://sourceforge.net/projects/crunch-wordlist'
  url 'https://downloads.sourceforge.net/project/crunch-wordlist/crunch-wordlist/crunch-3.5.tgz'
  sha1 '9caa1727d81f178805815a63e8d72736b750210c'

  def install
    system "make", "CC=#{ENV.cc}", "LFS=-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"

    bin.install "crunch"
    man1.install "crunch.1"
    share.install Dir["*.lst"]
  end
end
