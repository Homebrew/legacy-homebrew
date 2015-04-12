class Nrg2iso < Formula
  homepage "http://gregory.kokanosky.free.fr/v4/linux/nrg2iso.en.html"
  url "http://gregory.kokanosky.free.fr/v4/linux/nrg2iso-0.4.tar.gz"
  sha256 "25049d864680ec12bbe31b20597ce8c1ba3a4fe7a7f11e25742b83e2fda94aa3"

  def install
    system "make"
    bin.install "nrg2iso"
  end

  test do
    assert_equal "nrg2iso v#{version}",
      shell_output("#{bin}/nrg2iso --version").chomp
  end
end
