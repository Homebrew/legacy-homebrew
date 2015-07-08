class Ttyrec < Formula
  desc "Terminal interaction recorder and player"
  homepage "http://0xcc.net/ttyrec/"
  url "http://0xcc.net/ttyrec/ttyrec-1.0.8.tar.gz"
  sha256 "ef5e9bf276b65bb831f9c2554cd8784bd5b4ee65353808f82b7e2aef851587ec"

  bottle do
    cellar :any
    sha256 "71882b7cbbd055cee53e5db3110c0cb00f315e00e00258350b147c1e73807203" => :yosemite
    sha256 "3980851f760e70ca0eca0dca0101c2e65bd6f3a17fda14557482ae428d4f162b" => :mavericks
    sha256 "2ec245ff0f7e2340f6837ef6973696cd6efb8ded899bc9b9070c0f2dff6aa780" => :mountain_lion
  end

  resource "matrix.tty" do
    url "http://0xcc.net/tty/tty/matrix.tty"
    sha256 "76b8153476565c5c548aa04c2eeaa7c7ec8c1385bcf8b511c68915a3a126fdeb"
  end

  def install
    system "make"
    bin.install %w[ttytime ttyplay ttyrec]
    man1.install Dir["*.1"]
  end

  test do
    resource("matrix.tty").stage do
      assert_equal "9\tmatrix.tty", shell_output("ttytime matrix.tty").strip
    end
  end
end
