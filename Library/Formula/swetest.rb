require "formula"

class Swetest < Formula
  homepage "http://www.astro.com/swisseph/"
  url "http://www.astro.com/ftp/swisseph/swe_unix_src_2.00.00.tar.gz"
  sha1 "db521595e097937ba8ca8bbc8405a6410626685a"

  version "2.00.00"

  resource "sweph" do
    url "http://www.astro.com/ftp/swisseph/ephe/archive_gzip/sweph_18.tar.gz"
    sha1 "828661739258839d77aa9eb8c36f084c126039ae"
  end

  def install
    # hack away the epehemeris path, as the default won't do.
    system "echo \"#define SE_EPHE_PATH \\\".:#{prefix}/share\\\"\" >> src/swephexp.h"

    # we have to clean because the archive already has a linux compiled library
    system "make -C src clean"
    system "make -C src swetest"

    bin.install "src/swetest"

    # install ephemeris
    share.install resource("sweph")
  end

  test do
    system "#{bin}/swetest -h"
  end
end
