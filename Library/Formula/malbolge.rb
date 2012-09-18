require 'formula'

class Malbolge < Formula

  url 'http://esoteric.sange.fi/orphaned/malbolge/malbolge.c'
  homepage 'http://esoteric.sange.fi/orphaned/malbolge/README.txt'
  sha1 'caea2eb8c51486b4de57bdfa5ed4deba431e9e20'
  version '0.1.0'

  def patches
    DATA
  end

  def install
    system ENV.cxx, "malbolge.c", "-o", "malbolge"
    bin.install 'malbolge'
  end
end

__END__
--- /malbolge.c
+++ /malbolge.c 
25d24
< #include <malloc.h>
