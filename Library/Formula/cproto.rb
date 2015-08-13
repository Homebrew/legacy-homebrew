class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "http://invisible-island.net/cproto"
  url "ftp://invisible-island.net/cproto/cproto-4.7m.tgz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/cproto/cproto_4.7m.orig.tar.gz"
  sha256 "4b482e80f1b492e94f8dcda74d25a7bd0381c870eb500c18e7970ceacdc07c89"

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
    assert_match(/int woot.void.;/, shell_output("#{bin}/cproto woot.c"))
  end
end
