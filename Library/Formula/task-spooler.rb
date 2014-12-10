require 'formula'

class TaskSpooler < Formula
  homepage 'http://vicerveza.homeunix.net/~viric/soft/ts/'
  url 'http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.7.4.tar.gz'
  sha1 '92813a3b0eedfe1d4a177727122e6d08695f6bc8'

  conflicts_with 'moreutils',
    :because => "both install a 'ts' executable."

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
