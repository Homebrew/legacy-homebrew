class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/greyblake/crystal-icr"
  url "https://github.com/greyblake/crystal-icr/archive/master.tar.gz"
  sha256 "6c907f2f369f3b08e7e3496b1cd3210731e3792c12ce7bae3017255b222d040f"

  version "0.1.0"

  depends_on "crystal-lang" => :build

  def install
    system "make"
    bin.install "bin/icr"
  end
end
