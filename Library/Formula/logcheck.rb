class Logcheck < Formula
  homepage "https://logcheck.alioth.debian.org/"
  url "http://ftp.de.debian.org/debian/pool/main/l/logcheck/logcheck_1.3.17.tar.xz"
  sha1 "adb54e75f8a17e3aff4abb3066122c0dfdde21e3"

  bottle do
    cellar :any
    sha1 "94773d87f8879d53bdcaa26853342d7a45af1da8" => :yosemite
    sha1 "88197b7fa15f6842a2fe3e07f38e825e7b02947e" => :mavericks
    sha1 "c2b5c09aae9987d2441ca205d74ce44439e912c0" => :mountain_lion
  end

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
