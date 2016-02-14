class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/greyblake/crystal-icr"
  url "https://github.com/greyblake/crystal-icr/archive/v0.2.3.tar.gz"
  sha256 "f56acac90c1f6cee42925ad986ade89df6422ce75f135373a121b810f1a113f0"

  depends_on "crystal-lang"

  def install
    system "make"
    bin.install "bin/icr"
  end

  test do
    assert_equal "=> 4", pipe_output("#{bin}/icr", "2+2").strip
  end
end
