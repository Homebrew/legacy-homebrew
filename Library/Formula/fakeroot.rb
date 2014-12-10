require "formula"

class Fakeroot < Formula
  homepage "https://tracker.debian.org/pkg/fakeroot"

  stable do
    url "https://mirrors.kernel.org/debian/pool/main/f/fakeroot/fakeroot_1.18.4.orig.tar.bz2"
    mirror "http://ftp.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.18.4.orig.tar.bz2"
    sha1 "60cdd12ea3a72f3676c0f3930ab908ff1f13b996"

    # Monitor this with each release
    # https://github.com/Homebrew/homebrew/issues/33400#issuecomment-59827330
    depends_on MaximumMacOSRequirement => :mavericks
  end

  head "https://anonscm.debian.org/git/users/clint/fakeroot.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-static",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "root", shell_output("#{bin}/fakeroot whoami").strip
  end
end
