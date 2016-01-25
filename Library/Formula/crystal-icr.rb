class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/greyblake/crystal-icr"
  url "https://github.com/greyblake/crystal-icr/archive/v0.1.2.tar.gz"
  sha256 "10a564e3d34524f480cd13214666d48530cb0120bb8139179624a228c6a6b373"

  depends_on "crystal-lang" => :build

  def install
    system "make"
    bin.install "bin/icr"
  end

  test do
  end
end
