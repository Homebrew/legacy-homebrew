require 'formula'

class Unoconv < Formula
  homepage 'http://dag.wieers.com/home-made/unoconv/'
  url 'https://github.com/downloads/dagwieers/unoconv/unoconv-0.5.tar.bz2'
  head 'https://github.com/dagwieers/unoconv.git'
  sha1 'b9bba1397b0ddc3279fef8abbf9edc75b04f2467'

  # BSD `install` doesn't support -D option, so we create dirs separately
  def patches
      DATA
  end

  def install
    system "make install prefix=#{prefix}"
  end
end

__END__
diff --git a/Makefile b/Makefile
index d6063e3..adf9be5 100644
--- a/Makefile
+++ b/Makefile
@@ -32,8 +32,10 @@ docs-install:
 	$(MAKE) -C docs install
 
 install:
-	install -Dp -m0755 unoconv $(DESTDIR)$(bindir)/unoconv
-	install -Dp -m0644 docs/unoconv.1 $(DESTDIR)$(mandir)/man1/unoconv.1
+	install -d $(DESTDIR)$(bindir)/
+	install -d $(DESTDIR)$(mandir)/man1/
+	install -p -m0755 unoconv $(DESTDIR)$(bindir)/unoconv
+	install -p -m0644 docs/unoconv.1 $(DESTDIR)$(mandir)/man1/unoconv.1
 
 install-links: $(links)
