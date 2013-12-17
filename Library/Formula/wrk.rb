require 'formula'

class Wrk < Formula
  homepage 'https://github.com/wg/wrk'
  url 'https://github.com/wg/wrk/archive/3.0.4.tar.gz'
  sha1 '55ac8311878f81a6cc9d649da930792e2efb6fe7'
  head 'https://github.com/wg/wrk.git'

  conflicts_with 'wrk-trello', :because => 'both install `wrk` binaries'

  def install
    ENV.j1
    system "make"
    bin.install "wrk"
  end

  test do
    system *%W{#{bin}/wrk -c 1 -t 1 http://www.github.com/}
  end
end
