require "formula"

class Profanity < Formula
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.4.2.tar.gz"
  sha1 "1af17e68a5b6142a996b95168322c88ec4a2720b"
  head "https://github.com/boothj5/profanity.git"

  bottle do
    sha1 "d0f6236615ac6535042e976856837ccf90cdcc3d" => :mavericks
    sha1 "22c48eb0d161da4ace8adadee5c251a3a3933eb8" => :mountain_lion
    sha1 "54b24ff622f05b071084ef53a9bf03c8327e58d9" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libstrophe"
  depends_on "glib"
  depends_on "openssl"
  depends_on "gnutls"
  depends_on "libotr" => :recommended
  depends_on "terminal-notifier" => :optional

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "profanity", "-v"
  end
end
