class Ttyrec < Formula
  homepage "http://0xcc.net/ttyrec/"
  url "http://0xcc.net/ttyrec/ttyrec-1.0.8.tar.gz"
  sha256 "ef5e9bf276b65bb831f9c2554cd8784bd5b4ee65353808f82b7e2aef851587ec"

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
