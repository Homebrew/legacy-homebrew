class Malbolge < Formula
  desc "Deliberately difficult to program esoteric programming language"
  homepage "http://esoteric.sange.fi/orphaned/malbolge/README.txt"
  url "http://esoteric.sange.fi/orphaned/malbolge/malbolge.c"
  version "0.1.0"
  sha256 "ca3b4f321bc3273195eb29eee7ee2002031b057c2bf0c8d7a4f7b6e5b3f648c0"

  patch :DATA

  def install
    system ENV.cxx, "malbolge.c", "-o", "malbolge"
    bin.install "malbolge"
  end
end

__END__
--- /malbolge.c
+++ /malbolge.c 
25d24
< #include <malloc.h>
