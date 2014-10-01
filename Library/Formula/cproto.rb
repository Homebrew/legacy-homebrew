require "formula"

class Cproto < Formula
  homepage "http://invisible-island.net/cproto"
  url "ftp://invisible-island.net/cproto/cproto-4.7l.tgz"
  sha1 "528d7b172cf206ad5b399e9c48d66eaa5029db86"

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
