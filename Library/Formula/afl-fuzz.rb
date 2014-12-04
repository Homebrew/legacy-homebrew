require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-0.85b.tgz"
  sha1 "036c6064b24c3211524d7713d9b0f0590d7255f7"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # afl-fuzz only runs interactively and doesn't have a version flag to
    # simply test if it installed successfully. Instead we just run it and
    # hope that it prints its name somewhere in its output (which we expect it
    # to in its banner).
    assert `#{bin}/afl-fuzz`.include? "afl-fuzz"
  end
end
