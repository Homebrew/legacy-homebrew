class Lablgtk < Formula
  desc "Objective Caml interface to gtk+"
  homepage "http://lablgtk.forge.ocamlcore.org"
  url "https://forge.ocamlcore.org/frs/download.php/1479/lablgtk-2.18.3.tar.gz"
  sha256 "975bebf2f9ca74dc3bf7431ebb640ff6a924bb80c8ee5f4467c475a7e4b0cbaf"

  bottle do
    revision 1
    sha256 "ea5827e301ae1bf1b8f8d2b9e68c4f9066e99410bec60c5c3fb72c283cf6a333" => :yosemite
    sha256 "543db1eed44c7853960eb88b433a18bea2f04831167d24303fd14d9e161bd98c" => :mavericks
    sha256 "cb3caa949fd2a83a123a6282a48c35bd296a36d6a8f3975376497cef671aa597" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "camlp4" => :build
  depends_on "objective-caml"
  depends_on "gtk+"
  depends_on "librsvg"

  def install
    system "./configure", "--bindir=#{bin}",
                          "--libdir=#{lib}",
                          "--mandir=#{man}",
                          "--with-libdir=#{lib}/ocaml"
    ENV.j1
    system "make", "world"
    system "make", "old-install"
  end

  test do
    (testpath/"test.ml").write <<-EOS.undent
      let main () =
        GtkMain.Main.init ()
      let _ = main ()
    EOS
    ENV["CAML_LD_LIBRARY_PATH"] = "#{lib}/ocaml/stublibs"
    flags = %W[
      -cclib
      -latk-1.0
      -cclib
      -lcairo
      -cclib
      -lgdk-quartz-2.0
      -cclib
      -lgdk_pixbuf-2.0
      -cclib
      -lgio-2.0
      -cclib
      -lglib-2.0
      -cclib
      -lgobject-2.0
      -cclib
      -lgtk-quartz-2.0
      -cclib
      -lgtksourceview-2.0
      -cclib
      -lintl
      -cclib
      -lpango-1.0
      -cclib
      -lpangocairo-1.0
    ]
    system "ocamlc", "-I", "#{Formula["lablgtk"].opt_lib}/ocaml/lablgtk2", "lablgtk.cma", "gtkInit.cmo", "test.ml", "-o", "test", *flags
    system "./test"
  end
end
