require 'formula'

class Mldonkey < Formula
  homepage 'http://mldonkey.sourceforge.net/Main_Page'
  url 'http://downloads.sourceforge.net/project/mldonkey/mldonkey/3.1.2/mldonkey-3.1.2.tar.bz2'
  sha1 'be8c261e2fbd365dd3866af15a854b074fbc59c1'

  depends_on 'objective-caml'
  depends_on :libpng

  if ARGV.include? "--with-x"
    depends_on 'librsvg'
    depends_on 'lablgtk'
  end

  def options
    [["--with-x", "Build mldonkey with X11 support"]]
  end

  # Patches fix two compile errors with both clang and llvm.  Reported as
  # https://savannah.nongnu.org/patch/?7727 and in the following:
  # https://savannah.nongnu.org/bugs/index.php?36654
  # These patches are not yet in HEAD as of 13 JUN 2012. They do work according
  # to the user report in issue #12774.
  def patches
    DATA
  end

  def install
    # Fix compiler selection
    ENV['OCAMLC'] = "#{HOMEBREW_PREFIX}/bin/ocamlc.opt -cc #{ENV.cc}"

    # Let it build with standard Homebrew optimization
    inreplace 'Makefile', '-O3', ''

    args = ["--prefix=#{prefix}"]
    args << "--enable-gui=newgui2" if ARGV.include? "--with-x"

    system "./configure", *args
    system "make install"
  end
end

__END__
--- a/Makefile	2012-04-05 07:11:34.000000000 -0700
+++ b/Makefile	2012-06-13 19:32:25.000000000 -0700
@@ -5447,7 +5447,7 @@
 	$(OCAMLC) $(DEVFLAGS) $(INCLUDES) -c $<
 
 .mlcpp.ml:
-	@$(CPP) -x c -P $< $(FIX_BROKEN_CPP) -o $@
+	cpp -P $< $(FIX_BROKEN_CPP) > $@
 
 %.ml: %.mlp $(BITSTRING)/pa_bitstring.cmo
 	$(CAMLP4OF) build/bitstring.cma $(BITSTRING)/bitstring_persistent.cmo $(BITSTRING)/pa_bitstring.cmo -impl $< -o $@
--- a/config/Makefile.in	2012-04-04 13:22:49.000000000 -0700
+++ b/config/Makefile.in	2012-06-13 19:33:02.000000000 -0700
@@ -1848,7 +1848,7 @@
 	$(OCAMLC) $(DEVFLAGS) $(INCLUDES) -c $<
 
 .mlcpp.ml:
-	@$(CPP) -x c -P $< $(FIX_BROKEN_CPP) -o $@
+	cpp -P $< $(FIX_BROKEN_CPP) > $@
 
 %.ml: %.mlp $(BITSTRING)/pa_bitstring.cmo
 	$(CAMLP4OF) build/bitstring.cma $(BITSTRING)/bitstring_persistent.cmo $(BITSTRING)/pa_bitstring.cmo -impl $< -o $@
