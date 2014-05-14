require 'formula'

class Fswatch < Formula
  homepage 'https://github.com/alandipert/fswatch'
  url 'https://github.com/alandipert/fswatch/archive/v1.3.2.tar.gz'
  sha1 'c8749d478fb0bfab01fb014bd39b2830e0cdd93e'

  def install
    system './configure'
    system 'make'
    bin.install 'fswatch'
  end

  test do
    system "fswatch 2>&1| grep 'You must specify a directory to watch'"
  end
end
