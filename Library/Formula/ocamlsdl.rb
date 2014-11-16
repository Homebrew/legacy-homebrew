require "formula"

class Ocamlsdl < Formula
  homepage "http://ocamlsdl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  sha1 "2e54f8984b06cede493c3ad29006dde17077a79a"

  bottle do
    cellar :any
    sha1 "69e4eab5739ee4cece742d1064c36f61fb055395" => :mavericks
    sha1 "d12bd3c25db05daa8e2a9a40f8f4d821b0e31073" => :mountain_lion
    sha1 "c2d29344d6062efb1a5c5dced9de2b58d3778312" => :lion
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
    (testpath/'test.ml').write <<-EOS.undent
      let main () =
        Sdl.init [`VIDEO];
        Sdl.quit ()

      let _ = main ()
    EOS
    system "ocamlopt", "-I", "+sdl", "sdl.cmxa", "-cclib", "-lSDLmain", "-cclib", "-lSDL", "-cclib", "-Wl,-framework,Cocoa", "-o", "test" "test.ml"
  end
end
