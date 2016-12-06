require 'formula'

class Fswatch < Formula
  homepage 'https://github.com/alandipert/fswatch'
  url 'https://github.com/alandipert/fswatch.git'
  sha1 'bceca01f65e0caef0bcfebbcac5210c9280f741e'
  version "0.0.1"

  def install
    system "make"
    cp 'fswatch', File.join(HOMEBREW_PREFIX, 'bin', 'fswatch')
  end

  test do
    system "which fswatch"
  end
end
