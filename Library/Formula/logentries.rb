require 'formula'

class Logentries < Formula
  homepage 'https://logentries.com/doc/agent/'
  url 'https://github.com/logentries/le/archive/v1.2.11.tar.gz'
  sha1 'f10a172a792799e4e75a93d55e2746631a845dab'

  def install
    bin.install 'le'
  end
end
