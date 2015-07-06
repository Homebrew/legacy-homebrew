class Pgroonga < Formula
  desc "An extension for PostgreSQL to use Groonga as an index."
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-0.6.0.tar.gz"
  sha256 "29a631f68013bba19321beac0d7b933eafce60aec1597aa8fff0b0898ff2a73d"

  depends_on "pkg-config" => :build
  depends_on "postgresql"
  depends_on "groonga"

  def pour_bottle?
    # Postgres extensions must live in the Postgres prefix, which precludes
    # bottling: https://github.com/Homebrew/homebrew/issues/10247
    # Overcoming this will likely require changes in Postgres itself.
    false
  end

  def install
    system "make"
    system "make", "install"
  end
end
