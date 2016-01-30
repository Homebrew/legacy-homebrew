class Oksh < Formula
  desc "portable OpenBSD ksh (a maintained pdksh/ksh88 clone)"

  # Note that this is *not* the same project as https://connochaetos.org/oksh,
  # (linked at: http://freecode.com/projects/oksh). Though the intent of these
  # projects is the same, that version was intentionally relicesed as GPL3 and
  # should be avoided. https://github.com/ibara/oksh retains BSD/ISC license.

  homepage "https://github.com/ibara/oksh"
  url "http://devio.us/~bcallah/oksh/oksh-6.tar.gz"
  sha256 "2acbb03ac5e5322011694c3e2f21024f4940bb58e9a6a4e6d1dc19cb4789c75b"
  head "https://github.com/ibara/oksh.git"

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system "oksh", "-c", "echo \"PS1='\\u@\\h'\" works in oksh but not pdksh."
  end
end
