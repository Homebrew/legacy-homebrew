require 'formula'

class Inkmake < Formula
  homepage 'https://github.com/wader/inkmake'
  url 'https://github.com/wader/inkmake.git', :revision => '090764e125b7adfa435040a30bfff47aa96b60f2'
  version '0.1'
  head 'https://github.com/wader/inkmake.git', :branch => 'master'

  def install
    bin.install "inkmake"
  end
end
