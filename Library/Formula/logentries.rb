require 'formula'

class Logentries < Formula
  homepage 'https://logentries.com/doc/agent/'
  url 'https://github.com/logentries/le/archive/v1.2.6.tar.gz'
  sha1 'e753f6c662d4e4fc544b8655e84d5adecfa48f97'

  def install
    bin.install 'le'
  end
end
