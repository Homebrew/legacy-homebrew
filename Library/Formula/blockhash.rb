class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "http://blockhash.io/"
  url "https://github.com/commonsmachinery/blockhash/archive/0.1.tar.gz"
  sha256 "aef300f39be2cbc1b508af15d7ddb5b851b671b27680d8b7ab1d043cc0369893"
  head "https://github.com/commonsmachinery/blockhash.git"

  bottle do
    cellar :any
    revision 1
    sha256 "84a9ec978c225087a1699cc53490c18ed8447e115968bf66c12beea8e501e107" => :el_capitan
    sha256 "cbd13eb4fd577a7bd20fae814ae5a303fa7c4dd17a382c9a74acbed6977b676f" => :yosemite
    sha256 "3ca5aeb1b8324803f6f40ee08b2acbb1cb8a57328c8fcb3c776c8192d01beb25" => :mavericks
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
