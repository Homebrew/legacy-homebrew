require 'formula'

class Ddate < Formula
  homepage 'https://github.com/bo0ts/ddate'
  url 'https://github.com/woodruffw/ddate/archive/v0.2.1-osx.tar.gz'
  version '0.2.1'
  sha1 '38d3d4d2730ae982a57a1000fdb3401e25d61a5d'

  def install
    system ENV.cc, 'ddate.c', '-o', 'ddate'
    bin.install 'ddate'
    man1.install 'ddate.1'
  end
end
