require 'formula'

class Sc <Formula
  url 'http://www.ibiblio.org/pub/linux/apps/financial/spreadsheet/sc-7.16.tar.gz'
  homepage 'http://www.ibiblio.org/pub/linux/apps/financial/spreadsheet/sc-7.16.lsm'
  md5 '1db636e9b2dc7cd73c40aeece6852d47'

  skip_clean 'share/sc/plugins'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! 'prefix', prefix
      s.change_make_var! 'EXDIR', bin
      s.change_make_var! 'MANDIR', man1
      s.change_make_var! 'LIBDIR', "#{share}/sc"
    end
    system "make install"
  end

  def patches
    # The Makefile for sc 7.16 doesn't work well with dirs like Homebrew uses;
    # also, it looks unmaintained, so these changes are unlikely to be applied
    DATA
  end

end

__END__

diff --git a/Makefile b/Makefile
index f3007b4..2e3a73c 100644
--- a/Makefile
+++ b/Makefile
@@ -499,14 +499,17 @@ install: $(EXDIR)/$(name) $(EXDIR)/$(name)qref $(EXDIR)/p$(name) \
 	 $(MANDIR)/p$(name).$(MANEXT)
 
 $(EXDIR)/$(name): $(name)
+	-mkdir -p $(EXDIR)
 	cp $(name) $(EXDIR)
 	strip $(EXDIR)/$(name)
 
 $(EXDIR)/$(name)qref: $(name)qref
+	-mkdir -p $(EXDIR)
 	cp $(name)qref $(EXDIR)
 	strip $(EXDIR)/$(name)qref
 
 $(EXDIR)/p$(name): p$(name)
+	-mkdir -p $(EXDIR)
 	cp p$(name) $(EXDIR)
 	strip $(EXDIR)/p$(name)
 
@@ -516,9 +519,10 @@ $(LIBDIR)/tutorial: tutorial.sc $(LIBDIR)
 	chmod $(MANMODE) $(LIBDIR)/tutorial.$(name)
 
 $(LIBDIR):
-	mkdir $(LIBDIR)
+	-mkdir -p $(LIBDIR)
 
 $(MANDIR)/$(name).$(MANEXT): $(name).1
+	-mkdir -p $(MANDIR)
 	cp $(name).1 $(MANDIR)/$(name).$(MANEXT)
 	chmod $(MANMODE) $(MANDIR)/$(name).$(MANEXT)
 
