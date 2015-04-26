class Envchain < Formula
  homepage "https://github.com/sorah/envchain"
  head "https://github.com/sorah/envchain.git"
  url "https://github.com/sorah/envchain/archive/v0.2.0.tar.gz"
  sha256 "2a863688d1e0bdc47ba8339f57c8b5e22f5002fd3ab58928766e45f23c6ca267"

  def install
    system "make", "DESTDIR=#{prefix}", "install"
  end

  test do
    assert_match /envchain version #{version}/, shell_output("#{bin}/envchain 2>&1", 2)
  end
end
