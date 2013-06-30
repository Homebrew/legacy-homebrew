require 'formula'

class FswatchStdout < Formula
  homepage 'https://github.com/unphased/fswatch'
  url 'https://github.com/unphased/fswatch', :revision => 'c6bdb93e1072f7184ccc10da63100b0e0c1cd800'
  version '2013-06-22'

  head 'https://github.com/unphased/fswatch.git', :branch => 'master'

  def install
    system "make all"
    mv "fswatch", "fswatch-stdout"
    bin.install "fswatch-stdout"
  end

  def test
    system "#{bin}/fswatch-stdout"
  end
end
