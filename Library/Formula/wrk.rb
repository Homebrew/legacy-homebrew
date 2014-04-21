require 'formula'

class Wrk < Formula
  homepage 'https://github.com/wg/wrk'
  url 'https://github.com/wg/wrk/archive/3.1.0.tar.gz'
  sha1 '3ddc1e591a846b92899a534abf4bc49d2c6cd98e'
  head 'https://github.com/wg/wrk.git'

  depends_on 'openssl'

  conflicts_with 'wrk-trello', :because => 'both install `wrk` binaries'

  def install
    ENV.j1
    system "make"
    bin.install "wrk"
  end

  test do
    system *%W{#{bin}/wrk -c 1 -t 1 https://github.com/}
  end
end
