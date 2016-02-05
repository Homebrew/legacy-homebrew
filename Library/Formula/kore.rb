class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/release/kore-1.2.3-release.tgz"
  sha256 "24f1a88f4ef3199d6585f821e1ef134bb448a1c9409a76d18fcccd4af940d32f"

  head "https://github.com/jorisvink/kore.git"

  bottle do
    sha256 "cba37916c300a8c35d9dab23dabdd2de0abb7eef560fa4f8328195f5543854fa" => :yosemite
    sha256 "42baed336207505fcbd03f95f5e3a842413569b987ef0f5e568350f81e66bfbd" => :mavericks
    sha256 "dbb9515b193dc3caa5ada4dd048d42ea8794ecab27d1420c051979ebe456276a" => :mountain_lion
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
