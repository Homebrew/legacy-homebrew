require 'formula'

class Wrk < Formula
  homepage 'https://github.com/wg/wrk'
  url 'https://github.com/wg/wrk/archive/3.1.0.tar.gz'
  sha1 '3ddc1e591a846b92899a534abf4bc49d2c6cd98e'
  head 'https://github.com/wg/wrk.git'

  bottle do
    cellar :any
    sha1 "49bb12722e5def595b7e5840b299c44729559735" => :mavericks
    sha1 "fae8eceb0061b9f2ee994d961e11050d46180a52" => :mountain_lion
    sha1 "f5ef7225b4b441ae8b6ab87c6565d7d432283299" => :lion
  end

  depends_on 'openssl'

  conflicts_with 'wrk-trello', :because => 'both install `wrk` binaries'

  def install
    ENV.j1
    system "make"
    bin.install "wrk"
  end

  test do
    system *%W{#{bin}/wrk -c 1 -t 1 -d 1 http://example.com/}
  end
end
