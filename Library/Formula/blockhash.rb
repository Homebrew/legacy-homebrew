class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "http://blockhash.io/"
  url "https://github.com/commonsmachinery/blockhash/archive/0.1.tar.gz"
  sha256 "aef300f39be2cbc1b508af15d7ddb5b851b671b27680d8b7ab1d043cc0369893"
  head "https://github.com/commonsmachinery/blockhash.git"

  bottle do
    cellar :any
    sha256 "73521bf91681f57dc01b0b5727f14e2ff36f0b1f0b3220661beaf18c62987e06" => :yosemite
    sha256 "2760541166d22bacba3ebb6692523cdec601e6a257584a8bb56be83a19d73d2f" => :mavericks
    sha256 "d975cead300bea505d86ac0478baa012f18b103d9250826feeab287e1c3a2b0a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "imagemagick"

  resource "testdata" do
    url "https://raw.githubusercontent.com/commonsmachinery/blockhash/ce08b465b658c4e886d49ec33361cee767f86db6/testdata/clipper_ship.jpg"
    sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    resource("testdata").stage testpath
    hash = "00007ffe7ffe7ffe7ffe7ffe7ffe77fe77fe600e7f5e00000000000000000000"
    # Exit status is not meaningful, so use pipe_output instead of shell_output
    # for now
    # https://github.com/commonsmachinery/blockhash/pull/9
    result = pipe_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg", nil, nil)
    assert_match hash, result
  end
end
