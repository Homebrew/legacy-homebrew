require 'formula'

class Fswatch < Formula

  homepage 'https://github.com/alandipert/fswatch'
  url 'https://github.com/alandipert/fswatch.git', :revision => 'a6ff7fde6f1775a40a8517aa48958d9ff23a120f'
  version '2012-11-16'

  head 'https://github.com/alandipert/fswatch.git', :branch => 'master'

  def install
    system "make all"
    bin.install "fswatch"
  end

end
