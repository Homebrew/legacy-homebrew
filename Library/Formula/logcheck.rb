class Logcheck < Formula
  homepage "http://logcheck.alioth.debian.org/"
  url "http://ftp.de.debian.org/debian/pool/main/l/logcheck/logcheck_1.3.17.tar.xz"
  sha1 "adb54e75f8a17e3aff4abb3066122c0dfdde21e3"

  def install
    system "make", "install",
                   "--always-make",
                   "DESTDIR=#{prefix}",
                   "SBINDIR=sbin",
                   "BINDIR=bin"
  end

  test do
    system "#{sbin}/logtail", "-f", "#{HOMEBREW_REPOSITORY}/README.md"
  end
end
