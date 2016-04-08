class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "http://ephemeralpg.org"
  url "http://ephemeralpg.org/code/ephemeralpg-1.9.tar.gz"
  mirror "https://bitbucket.org/eradman/ephemeralpg/get/ephemeralpg-1.9.tar.gz"
  sha256 "3caf06f2be5d9f206f3c1174cc0c44cc359357fc7d41da026f858e01ef192792"

  bottle do
    cellar :any_skip_relocation
    sha256 "e50efa09e441390165ec35db5a42965c102e989435ad18bffcc231b12f58c0bc" => :el_capitan
    sha256 "500fd314d36ec1ba114fddc4786835f7b511163b07824721524cadbb5e718b0b" => :yosemite
    sha256 "9994e0a34d6a0071abef009a15d5dfcc513412633368fb0245fe40e664be52bd" => :mavericks
  end

  depends_on :postgresql

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end

  test do
    system "#{bin}/pg_tmp", "selftest"
  end
end
