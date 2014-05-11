require 'formula'

class Notmuch < Formula
  homepage "http://notmuchmail.org"
  url "http://notmuchmail.org/releases/notmuch-0.17.tar.gz"
  sha1 "0fe14140126a0da04754f548edf7e7b135eeec86"

  depends_on "pkg-config" => :build
  depends_on "emacs" => :optional
  depends_on "xapian"
  depends_on "talloc"
  depends_on "gmime"

  # Fix for mkdir behavior change in 10.9:
  # http://notmuchmail.org/pipermail/notmuch/2013/016388.html
  patch :DATA

  def install
    args = ["--prefix=#{prefix}"]
    if build.with? "emacs"
      ENV.deparallelize # Emacs and parallel builds aren't friends
      args << "--with-emacs"
    else
      args << "--without-emacs"
    end
    system "./configure", *args

    system "make", "V=1", "install"
  end
end

__END__
diff --git a/Makefile.local b/Makefile.local
index 72524eb..c85e09c 100644
--- a/Makefile.local
+++ b/Makefile.local
@@ -236,11 +236,11 @@ endif
 quiet ?= $($(shell echo $1 | sed -e s'/ .*//'))
 
 %.o: %.cc $(global_deps)
-	@mkdir -p .deps/$(@D)
+	@mkdir -p $(patsubst %/.,%,.deps/$(@D))
 	$(call quiet,CXX $(CPPFLAGS) $(CXXFLAGS)) -c $(FINAL_CXXFLAGS) $< -o $@ -MD -MP -MF .deps/$*.d
 
 %.o: %.c $(global_deps)
-	@mkdir -p .deps/$(@D)
+	@mkdir -p $(patsubst %/.,%,.deps/$(@D))
 	$(call quiet,CC $(CPPFLAGS) $(CFLAGS)) -c $(FINAL_CFLAGS) $< -o $@ -MD -MP -MF .deps/$*.d
 
 .PHONY : clean
-- 
1.8.4.2
