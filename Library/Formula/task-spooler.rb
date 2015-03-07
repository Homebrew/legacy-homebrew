require 'formula'

class TaskSpooler < Formula
  homepage 'http://vicerveza.homeunix.net/~viric/soft/ts/'
  url 'http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.7.5.tar.gz'
  sha1 'c2a81abbc3bcec14629a3a288a06e1f0c57f175c'

  conflicts_with 'moreutils',
    :because => "both install a 'ts' executable."

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
