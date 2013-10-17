require 'formula'

class Tpp < Formula
  homepage 'http://synflood.at/tpp.html'
  url 'http://synflood.at/tpp/tpp-1.3.1.tar.gz'
  sha1 'e99fca1d7819c23d4562e3abdacea7ff82563754'

  option 'international', 'Copy README.de (German README file)'
  depends_on 'figlet' => :optional

  def install
    system "mv", "tpp.rb", "tpp"
    prefix.install ['contrib']
    prefix.install ['examples']
    bin.install('tpp')
    man1.install ['doc/tpp.1']
    doc.install ['README']
    doc.install ['CHANGES']
    doc.install ['DESIGN']
    doc.install ['COPYING']
    doc.install ['THANKS']
    NcursesRuby.new.brew do
      inreplace 'extconf.rb', '$CFLAGS  += " -g"', '$CFLAGS  += " -g -DNCURSES_OPAQUE=0"'
      system "ruby", "extconf.rb"
      system "make"
      system "mv", "ncurses_bin.bundle", "lib"
      system "rm", "lib/ncurses.rb"
      prefix.install ['lib']
      lib.install ['THANKS']
    end
  end

  def patches
    DATA
  end

  if build.include? 'international'
    doc.install ['README.de']
  end

  test do
    system "tpp"
  end
end

class NcursesRuby < Formula
  homepage 'http://ncurses-ruby.berlios.de'
  url 'http://switch.dl.sourceforge.net/project/ncurses-ruby.berlios/ncurses-ruby-1.3.1.tar.bz2'
  mirror 'http://freefr.dl.sourceforge.net/project/ncurses-ruby.berlios/ncurses-ruby-1.3.1.tar.bz2'
  sha1 'e50018fc906e5048403b277a898117e782e267c4'
end

__END__
diff --git a/tpp.rb b/tpp.rb
index 5aeb938..e5d4616 100755
--- a/tpp.rb
+++ b/tpp.rb
@@ -7,7 +7,8 @@ version_number = "1.3.1"
 # ncurses-ruby module fails.
 def load_ncurses
   begin
-    require "ncurses"
+    require "../lib/ncurses_bin"
+    require "../lib/ncurses_sugar"
     include Ncurses
   rescue LoadError
     $stderr.print <<EOF
