require "formula"

class Kore < Formula
  homepage "https://kore.io/"
  url "https://kore.io/release/kore-1.2.1-release.tgz"
  sha1 "7af8d3d651657e54cee4d90c9be33e9bde8a0727"

  head "https://github.com/jorisvink/kore.git"

  bottle do
    sha1 "595c33a520e0c7436cd5c4c411ea869566a351a0" => :yosemite
    sha1 "eec143a7a9ff07e8eb461d62d636a0fabdff3771" => :mavericks
    sha1 "fa26ba1e86bafdeb304280fcbec4e3faa1f9702b" => :mountain_lion
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
