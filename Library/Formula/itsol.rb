require "formula"

class Itsol < Formula
  homepage "http://www-users.cs.umn.edu/~saad/software/ITSOL"
  url "http://www-users.cs.umn.edu/~saad/software/ITSOL/ITSOL_2.tar.gz"
  sha1 "c7af215aaa6ab377521ba317eccf6859165ebefb"

  depends_on :fortran

  def install
    system "make"
    lib.install("LIB/libitsol.a")
    (include/"itsol").install Dir["INC/*.h"]
  end
end
