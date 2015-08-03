class Ocamlsdl < Formula
  desc "OCaml interface with the SDL C library"
  homepage "http://ocamlsdl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  sha256 "abfb295b263dc11e97fffdd88ea1a28b46df8cc2b196777093e4fe7f509e4f8f"
  revision 1

  bottle do
    cellar :any
    sha1 "c158c8f04e5679333db3c074943c3ea37fe8c9a5" => :yosemite
    sha1 "a64fd3f10a85599a9470b46a3b719e0d50d194e9" => :mavericks
    sha1 "e39fd75cfdbc4f3c0fc570beb4bfbe6e58301014" => :mountain_lion
  end

  depends_on "sdl"
  depends_on "sdl_mixer" => :recommended
  depends_on "sdl_image" => :recommended
  depends_on "sdl_gfx" => :recommended
  depends_on "sdl_ttf" => :recommended
  depends_on "objective-caml"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "OCAMLLIB=#{lib}/ocaml"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.ml").write <<-EOS.undent
      let main () =
        Sdl.init [`VIDEO];
        Sdl.quit ()

      let _ = main ()
    EOS
    system "ocamlopt", "-I", "+sdl", "sdl.cmxa", "-cclib", "-lSDLmain", "-cclib", "-lSDL", "-cclib", "-Wl,-framework,Cocoa", "-o", "test" "test.ml"
  end
end
