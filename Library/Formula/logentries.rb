require 'formula'

class Logentries < Formula
  homepage 'https://logentries.com/doc/agent/'
  url 'https://github.com/logentries/le/archive/v1.2.14.tar.gz'
  sha1 'd0b8073c7d5cae990b186bacf1bb2e2d39c544a5'

  def install
    bin.install 'le'
  end
end
