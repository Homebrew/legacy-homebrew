require "formula"

class Cproto < Formula
  homepage "http://invisible-island.net/cproto"
  url "ftp://invisible-island.net/cproto/cproto-4.7l.tgz"
  sha1 "528d7b172cf206ad5b399e9c48d66eaa5029db86"

  bottle do
    cellar :any
    sha1 "0b0d9f789a5645ffea965f62251c9565f41fd2d9" => :mavericks
    sha1 "2b3b8f908e4db3575492588cc1aac60200ccafaa" => :mountain_lion
    sha1 "787dd0093d888d058dd291c3a4b60272180cc2d3" => :lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"woot.c").write("int woot() {\n}")

    assert_match(/int woot.void.;/,
                 shell_output("#{bin}/cproto woot.c"))
  end
end
