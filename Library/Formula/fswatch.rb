require 'formula'

class Fswatch < Formula
  homepage 'https://github.com/sdegutis/fswatch'
  url 'https://github.com/sdegutis/fswatch/tarball/v1'
  md5 '6fcb7b9a276a37a7695b7c279916e08c'

  def install
    system "make"
    bin.install "fswatch"
  end
end
