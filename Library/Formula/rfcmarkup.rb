class Rfcmarkup < Formula
  desc "Add HTML markup and links to internet-drafts and RFCs"
  homepage "https://tools.ietf.org/tools/rfcmarkup/"
  url "https://tools.ietf.org/tools/rfcmarkup/rfcmarkup-1.108.tgz"
  sha256 "77a78a1df5e155acb1df24ced950b9c7af022a71f07ad7eec2d64b9cc8ef5466"

  bottle do
    cellar :any
    sha256 "44a9b77ba4c5770813797b24e3bae75a9b5ad8dbd017ddd210c5c5919b788010" => :yosemite
    sha256 "d97af1d0123131ba3bcd55cb1359d02ad402a4d5073fbf550e77bb1e37767409" => :mavericks
    sha256 "71fa6ab7113c159ff80ae9eab0e2a7807552c51571f4bd645252bfdf670ed6fc" => :mountain_lion
  end

  def install
    bin.install "rfcmarkup"
  end

  test do
    system bin/"rfcmarkup", "--help"
  end
end
