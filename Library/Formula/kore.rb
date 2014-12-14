require "formula"

class Kore < Formula
  homepage "https://kore.io/"
  url "https://kore.io/release/kore-1.2.1-release.tgz"
  sha1 "7af8d3d651657e54cee4d90c9be33e9bde8a0727"

  head "https://github.com/jorisvink/kore.git"

  depends_on "openssl"
  depends_on "postgresql" => :recommended

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
