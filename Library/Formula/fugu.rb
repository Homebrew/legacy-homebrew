class Fugu < Formula
  homepage "https://github.com/mattes/fugu"
  url "https://github.com/mattes/fugu/releases/download/v1.1.1/fugu.v1.1.1.darwin.x86_64.tar.gz"
  version "1.1.1"
  sha256 "093b4f0d52c827061fa012e0242ac38fba32174ec666f5ba5d5d3ca70821d99d"

  def install
    bin.install "fugu.v1.1.1.darwin.x86_64" => "fugu"
  end

  test do
    assert_equal "1.1.1\n", pipe_output("fugu --version")
  end
end
