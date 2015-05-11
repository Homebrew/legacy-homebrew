class Rfcmarkup < Formula
  homepage "https://tools.ietf.org/tools/rfcmarkup/"
  url "https://tools.ietf.org/tools/rfcmarkup/rfcmarkup-1.108.tgz"
  sha256 "77a78a1df5e155acb1df24ced950b9c7af022a71f07ad7eec2d64b9cc8ef5466"

  def install
    bin.install "rfcmarkup"
  end

  test do
    system bin/"rfcmarkup", "--help"
  end
end
