require 'formula'

class Opam < Formula
  homepage 'https://github.com/OCamlPro/opam'
  url 'https://github.com/OCamlPro/opam/tarball/0.8.2'
  sha1 'a1a16cda2c58064d2f7e644da5fb045783d7b23d'

  depends_on "objective-caml"

  # Temporary patch until the next release
  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/opam --help"
  end

  def caveats; <<-EOS.undent
    OPAM uses ~/.opam by default to install packages, so you need to initialize
    the package database first by running (as a normal user):

    $  opam init

    and add the following line to ~/.profile to initialize the environment:

    $  eval `opam config -env`

    Documentation and tutorials are available at http://opam.ocamlpro.com
    EOS
  end
end


__END__
diff --git a/src_ext/Makefile b/src_ext/Makefile
index 29a9dc6..c5750b3 100644
--- a/src_ext/Makefile
+++ b/src_ext/Makefile
@@ -8,7 +8,7 @@ depends.ocp: depends.ocp.boot
 clone: cudf.stamp extlib.stamp ocaml-re.stamp ocamlgraph.stamp dose.stamp cmdliner.stamp

 cudf-0.6.3.tar.gz:
-	$(FETCH) -k https://gforge.inria.fr/frs/download.php/31543/cudf-0.6.3.tar.gz
+	$(FETCH) -k https://gforge.inria.fr/frs/download.php/31910/cudf-0.6.3.tar.gz

 cudf.stamp: cudf-0.6.3.tar.gz
	tar xfz cudf-0.6.3.tar.gz
