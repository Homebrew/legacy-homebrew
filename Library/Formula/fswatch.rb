require 'formula'

class Fswatch < Formula
  homepage 'https://github.com/alandipert/fswatch'
  url 'https://codeload.github.com/alandipert/fswatch/tar.gz/r0.0.1'
  sha1 'e24397925de76a9d0805331c387b6517bc18b0ed'
  version '0.0.1'

  def install
    system 'make'
    bin.install 'fswatch'
  end

  test do
    system "fswatch 2>&1| grep 'You must specify a directory to watch'"
  end
end
