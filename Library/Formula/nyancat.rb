require 'formula'

class Nyancat < Formula
  head  'git://github.com/klange/nyancat.git', :using => :git
  homepage 'https://github.com/klange/nyancat'

  def install
    system "make"
    bin.install Dir['src/nyancat']
  end
end
