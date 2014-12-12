require "formula"

class Kore < Formula
  homepage "https://kore.io/"
  url "https://kore.io/release/kore-1.2-stable.tgz"
  sha1 "cb7f9eb7151d612d9acffc5eed1d79c296baeeba"

  head "https://github.com/jorisvink/kore.git"

  depends_on "openssl"
  depends_on "postgresql" => :recommended

  def install
    args = []

    # The following inreplaces are a workaround. An upstream pull request has been
    # created to solve this problem. (https://github.com/jorisvink/kore/pull/25)
    inreplace "src/cli.c", / = "-I\/usr\/local\/include";/, " = \"-I#{include}\";"
    inreplace "Makefile", /\/usr\/local/, prefix

    args << "PGSQL=1" if build.with? "postgresql"

    system "make", "TASKS=1", *args
    bin.mkdir
    system "make", "install"
  end

  test do
    system "#{bin}/kore", "create", "test"
    system "#{bin}/kore", "build", "test"
    system "#{bin}/kore", "clean", "test"
  end
end
