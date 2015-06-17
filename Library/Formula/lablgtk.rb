class Lablgtk < Formula
  desc "Objective Caml interface to gtk+"
  homepage "http://lablgtk.forge.ocamlcore.org"
  url "https://forge.ocamlcore.org/frs/download.php/1479/lablgtk-2.18.3.tar.gz"
  sha256 "975bebf2f9ca74dc3bf7431ebb640ff6a924bb80c8ee5f4467c475a7e4b0cbaf"

  bottle do
    sha1 "f17c4f647c272598eebde8a169be6cdac11e30e5" => :yosemite
    sha1 "298b83442b6f6fd1eefd229ae3820267771b19bc" => :mavericks
    sha1 "d78c6d4a152d142372265af77e9ac95cfb9e92a8" => :mountain_lion
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
    system "ocamlc", "-I", "#{Formula["lablgtk"].opt_lib}/ocaml/lablgtk2", "lablgtk.cma", "gtkInit.cmo", "test.ml", "-o", "test"
    system "./test"
  end
end
