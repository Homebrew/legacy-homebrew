require 'formula'

class Itex2mml < Formula
  url 'http://golem.ph.utexas.edu/~distler/blog/files/itexToMML.tar.gz'
  homepage 'http://golem.ph.utexas.edu/~distler/blog/itex2MML.html'
  md5 '59a23131a7dc22f2d8fb7a2ca638d6b0'

  version '1.4.6'

  def install
    Dir.chdir("itex-src") do
      system "make"
      system "mkdir -p #{bin}"
      system "make install prefix=#{prefix}"
    end
  end

  def test
    system "#{bin}/itex2MML --version"
  end

  def patches
    # The itex2MML Makefile hardcodes installation to /usr/local/bin
    DATA
  end

end

__END__
diff --git a/itex-src/Makefile b/itex-src/Makefile
index 2c1a572..b5c7d33 100644
--- a/itex-src/Makefile
+++ b/itex-src/Makefile
@@ -7,7 +7,7 @@ RUBY=ruby
 
 RM=rm -f
 INSTALL=install -c
-BINDIR=/usr/local/bin
+BINDIR=${prefix}/bin
 
 YYPREFIX=itex2MML_yy
 
@@ -35,7 +35,7 @@ clean:
 		$(RM) y.tab.* lex.yy.c itex2MML *.o *.output *.so *.dll *.sl *.bundle itex2MML_ruby.c
 
 install:	itex2MML
-		$(INSTALL) itex2MML $(BINDIR)
+		$(INSTALL) itex2MML $(BINDIR)/itex2MML
 
 RUBY_CFLAGS = $(shell $(RUBY) -e 'require "rbconfig"; print Config::CONFIG["CFLAGS"]')
 RUBY_LD = $(shell $(RUBY) -e 'require "rbconfig"; print Config::CONFIG["LDSHARED"]')
