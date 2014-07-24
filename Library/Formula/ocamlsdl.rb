require "formula"

class Ocamlsdl < Formula
  homepage "http://ocamlsdl.sourceforge.net/"
  # URL that has been tested:
  # "http://sourceforge.net/projects/ocamlsdl/files/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  url "https://downloads.sourceforge.net/projects/ocamlsdl/files/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  sha1 "2e54f8984b06cede493c3ad29006dde17077a79a"

  depends_on "sdl"
  depends_on "sdl_mixer" => :recommended
  depends_on "sdl_image" => :recommended
  depends_on "sdl_gfx" => :recommended
  depends_on "sdl_ttf" => :recommended
  depends_on "objective-caml"


  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
