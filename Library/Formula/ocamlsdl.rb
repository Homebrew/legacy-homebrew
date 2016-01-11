class Ocamlsdl < Formula
  desc "OCaml interface with the SDL C library"
  homepage "http://ocamlsdl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  sha256 "abfb295b263dc11e97fffdd88ea1a28b46df8cc2b196777093e4fe7f509e4f8f"
  revision 1

  bottle do
    cellar :any
    sha256 "07e016c5fa22b040d4f6081bc5f63657d02cf08810ff0bd1271e3ccb81b386e7" => :yosemite
    sha256 "4708ebcb0d84023df49191db0d0af8d194247e882cf54c49c8165ba176b5ff59" => :mavericks
    sha256 "fa6e3d9f55b354bab9d346a046de292a2c813193087f62ee55c5d10d348097b8" => :mountain_lion
  end

  depends_on "sdl"
  depends_on "sdl_mixer" => :recommended
  depends_on "sdl_image" => :recommended
  depends_on "sdl_gfx" => :recommended
  depends_on "sdl_ttf" => :recommended
  depends_on "ocaml"

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
