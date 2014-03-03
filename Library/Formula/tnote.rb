require "formula"

class Tnote < Formula
  homepage "http://tnote.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tnote/tnote/tnote-0.2.1/tnote-0.2.1.tar.gz"
  sha1 "8d5d3694b921191c7e91e8907ec6c6970ce29ec6"

  def install
    bin.install 'tnote'
    man1.install 'tnote.1.gz'
  end
end
