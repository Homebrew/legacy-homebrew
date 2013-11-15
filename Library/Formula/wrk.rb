require 'formula'

class Wrk < Formula
  homepage 'https://github.com/wg/wrk'
  url 'https://github.com/wg/wrk/archive/3.0.3.tar.gz'
  sha1 '097168282266414a672c77f90761d786dec323f1'
  head 'https://github.com/wg/wrk.git'

  conflicts_with 'wrk-trello', :because => 'both install `wrk` binaries'

  def install
    ENV.j1
    system "make"
    bin.install "wrk"
  end

  test do
    system *%W{#{bin}/wrk -c 1 -r 1 -t 1 http://www.github.com/}
  end
end
