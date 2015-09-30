class Cscope < Formula
  desc "Tool for browsing source code"
  homepage "http://cscope.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cscope/cscope/15.8a/cscope-15.8a.tar.gz"
  sha256 "eb736ac40d5abebe8fa46820c7a8eccc8a17966a9a5f70375367b77177874d1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "10c4cd802d68e0c552a99e86b0609b882664583e39b9c3ff44591832e75277e2" => :el_capitan
    sha1 "75d73fea51fa5e4072134848a07c7c2f49308e35" => :yosemite
    sha1 "64cb7e095386c2119155b0be51b242860681e2ab" => :mavericks
    sha1 "bbccd86980669360c5085429a462166d8f238a15" => :mountain_lion
  end

  # Patch from http://bugs.gentoo.org/show_bug.cgi?ctype=html&id=111621
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    EOS
    (testpath/"cscope.files").write ("./test.c\n")
    system "#{bin}/cscope", "-b", "-k"
    assert_match /test\.c.*func/, shell_output("#{bin}/cscope -L1func")
  end
end

__END__
diff --git a/src/constants.h b/src/constants.h
index 7ad8005..844836e 100644
--- a/src/constants.h
+++ b/src/constants.h
@@ -103,7 +103,7 @@
 #define INCLUDES	8
 #define	FIELDS		10
 
-#if (BSD || V9) && !__NetBSD__ && !__FreeBSD__
+#if (BSD || V9) && !__NetBSD__ && !__FreeBSD__ && !__MACH__
 # define TERMINFO	0	/* no terminfo curses */
 #else
 # define TERMINFO	1
-- 
1.6.4

