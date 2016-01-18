class Ttyrec < Formula
  desc "Terminal interaction recorder and player"
  homepage "http://0xcc.net/ttyrec/"
  url "http://0xcc.net/ttyrec/ttyrec-1.0.8.tar.gz"
  sha256 "ef5e9bf276b65bb831f9c2554cd8784bd5b4ee65353808f82b7e2aef851587ec"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f24cda5af4db432d89cf3d3f5fb68a6f4afd1950c2c7e32456c8a8a779dfefd6" => :el_capitan
    sha256 "86ff5251f02aa7becad5f95ff8a6bdb62572d2cac4f99a72166bda8cfffc7981" => :yosemite
    sha256 "0324a2412722841b8f58bf41ab18d50e3dd15bed3d956f7d3738a6b1911f1130" => :mavericks
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
      assert_equal "9\tmatrix.tty", shell_output("#{bin}/ttytime matrix.tty").strip
    end
  end
end
