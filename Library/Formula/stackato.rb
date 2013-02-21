require 'formula'

class Stackato < Formula
  homepage 'http://www.activestate.com/stackato'
  url 'http://downloads.activestate.com/stackato/client/v1.6.2/stackato-1.6.2-macosx10.5-i386-x86_64.zip'
  version '1.6.2'
  sha1 '8b9c03380c65186f6bdbe39f4b1d9612ad221872'

  def install
    bin.install 'stackato'
  end

  def test
    system 'which stackato'
  end
end
