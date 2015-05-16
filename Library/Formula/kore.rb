require "formula"

class Kore < Formula
  homepage "https://kore.io/"
  url "https://kore.io/release/kore-1.2.2-release.tgz"
  sha256 "f58a00abcc8b02533eae63cc1d90701dcae92688e69534d13bde502ddcb2a06a"

  head "https://github.com/jorisvink/kore.git"

  bottle do
    sha256 "766f095f01beefc6de2b4a439b8ce7fab705076f5172b753c33c9168627940e1" => :yosemite
    sha256 "933d799a245c352069a1a17812818d5f238ab62e017d1962ea75fc89bce24bd7" => :mavericks
    sha256 "1a7cb118b4f562e3f3fedf2a4360de55978f0ed42c09afdf967156fc09fc2245" => :mountain_lion
  end

  depends_on "openssl"
  depends_on "postgresql" => :optional

  def install
    args = []

    args << "PGSQL=1" if build.with? "postgresql"

    system "make", "PREFIX=#{prefix}", "TASKS=1", *args
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/kore", "create", "test"
    system "#{bin}/kore", "build", "test"
    system "#{bin}/kore", "clean", "test"
  end
end
