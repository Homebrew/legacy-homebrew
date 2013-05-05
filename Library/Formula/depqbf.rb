require 'formula'

class Depqbf < Formula
  homepage 'http://lonsing.github.io/depqbf/'
  url 'https://github.com/lonsing/depqbf/archive/version-1.0.tar.gz'
  sha1 '117c3572f14eca154893449b23e09d9c556d3d2a'
  head 'https://github.com/lonsig/depqbf.git'

  # disable static linking against C runtime
  def patches
    DATA
  end

  def install
    system "make"
    bin.install "depqbf"
  end
end

# Warning: `brew pull` seems to smash line endings in this patch
__END__
diff --git a/makefile b/makefile
index 8614075..8e5466f 100644
--- a/makefile
+++ b/makefile
@@ -1,5 +1,5 @@
-#CFLAGS=-Wextra -Wall -Wno-unused -pedantic -std=c99 -DNDEBUG -O3 
-CFLAGS=-Wextra -Wall -Wno-unused -pedantic -std=c99 -DNDEBUG -O3 -static
+CFLAGS=-Wextra -Wall -Wno-unused -pedantic -std=c99 -DNDEBUG -O3
+#CFLAGS=-Wextra -Wall -Wno-unused -pedantic -std=c99 -DNDEBUG -O3 -static
 #CFLAGS=-Wextra -Wall -Wno-unused -pedantic -std=c99 -g3 -static
 #CFLAGS=-Wextra -Wall -Wno-unused -pedantic -std=c99 -DNDEBUG -g3 -pg -fprofile-arcs -ftest-coverage -static
 OBJECTS=qdpll_main.o qdpll_app.o qdpll.o qdpll_mem.o qdpll_dep_man_qdag.o
