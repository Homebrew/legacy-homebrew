require 'formula'

class TaskSpooler < Formula
  homepage 'http://vicerveza.homeunix.net/~viric/soft/ts/'
  url 'http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.7.3.tar.gz'
  sha1 '33b9321d4f48a2c2685a8240db4e00c0e69ef9bc'

  conflicts_with 'moreutils',
    :because => "both install a 'ts' executable."

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
