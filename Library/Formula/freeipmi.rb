require "formula"

class Freeipmi < Formula
  homepage "https://www.gnu.org/software/freeipmi/"
  url "http://ftpmirror.gnu.org/freeipmi/freeipmi-1.4.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.4.7.tar.gz"
  sha1 "3a93ecfafae6a6db4872efe5d7588c139928117b"

  bottle do
    sha1 "c26e226458270370b94b6c720af5eef27f8c09f5" => :yosemite
    sha1 "0574bbcf8a1f117c21b8c38871db1f1aa259bf15" => :mavericks
    sha1 "c7a586abb99e98bb03f7fa060c3b310b3eaf6edd" => :mountain_lion
  end

  depends_on "argp-standalone"
  depends_on "libgcrypt"

  def install
    system "./configure", "--prefix=#{prefix}"
    # This is a big hammer to disable building the man pages
    # It breaks under homebrew's build system and I'm not sure why
    inreplace "man/Makefile", "install: install-am", "install:"
    system "make", "install"
  end

  test do
    system "#{sbin}/ipmi-fru", "--version"
  end
end
