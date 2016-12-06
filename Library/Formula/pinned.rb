require 'formula'
class Pinned < Formula
  homepage 'http://nathanpc.github.com/pinned/'
  url 'https://github.com/nathanpc/pinned.git', :branch => 'master'
  version '1.0'
  def install
    system "make install"
  end
end
