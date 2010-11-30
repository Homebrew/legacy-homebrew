require 'formula'

class Lolcode <Formula
  homepage 'http://www.icanhaslolcode.org/'
  url 'https://github.com/justinmeza/lci/tarball/v0.9.2'
  head 'git://github.com/justinmeza/lolcode.git'
  md5 '04493a3e491723d2928eb37cd90bbf54'

  # Makefile 'lci' target depends on the compiler flag '-lm'
  def patches
    DATA
  end unless ARGV.build_head?

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "prefix", prefix
    end

    system "make"

    # v0.9.2 should use 'make install'.
    # Later versions can just copy the 'lolcode' bin.
    if ARGV.build_head?
      bin.install 'lolcode'
    else
      bin.mkpath
      system "make install"
    end
  end
end


__END__
diff --git a/Makefile b/Makefile
index ff3df8c..5fdedb5 100644
--- a/Makefile
+++ b/Makefile
@@ -11,7 +11,7 @@ testdir = ./test
 
 all: $(TARGET)
 
-$(TARGET): $(OBJS) $(LIBS)
+$(TARGET): $(OBJS)
 	$(CC) $(CPPFLAGS) -o $(TARGET) $(OBJS) $(LIBS)
 
 pedantic: $(OBJS) $(LIBS)
