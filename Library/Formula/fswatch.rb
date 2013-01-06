require 'formula'

class Fswatch < Formula
  homepage 'https://github.com/alandipert/fswatch'
  url 'https://github.com/alandipert/fswatch/tarball/a6ff7fde6f1775a40a8517aa48958d9ff23a120f'
  version "a6ff7fde6f"
  sha1 'f3b30fcc244011f77c6609a11963a7b15903bc19'

  def install
    system "make"
    system "install -p -m0755 fswatch #{HOMEBREW_PREFIX}/bin/fswatch" 
  end

  def test
    system "fswatch"
  end
end
