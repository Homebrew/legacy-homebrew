require 'formula'

class Ee < Formula
  homepage 'http://www.users.qwest.net/~hmahon/'
  url 'http://www.users.qwest.net/~hmahon/sources/ee-1.4.6.src.tgz'
  sha1 '6be7d03eade441a6c409b9d441ba2c144e26b157'

  def install
    system "make localmake"
    system "make all"

    # Install manually
    bin.install "ee"
    man1.install "ee.1"
  end
end
