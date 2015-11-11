class Lit < Formula
  desc "Toolkit for developing, sharing, and running luvit programs and libraries."
  homepage "https://github.com/luvit/lit"
  url "https://lit.luvit.io/packages/luvit/lit/v2.2.4.zip"
  sha256 "4d0ad9dce10c89e2f1cf483435c4670f5b3a22f69f73f834804b8b232411791f"

  depends_on "luvi" => :build

  def install
    system "luvi", buildpath, "--", "make"
    bin.install "lit"
  end

  test do
    system "#{bin}/lit"
  end
end

