require "formula"

class Camlp4 < Formula
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.02.1+1.tar.gz"
  sha1 "7d0f879517887299167f1c3eefa8f4d266d69183"
  head "https://github.com/ocaml/camlp4.git"

  depends_on "objective-caml"

  def install
    # this build fails if jobs are parallelized
    ENV.deparallelize
    system "./configure", "--bindir=#{bin}",
                          "--libdir=#{HOMEBREW_PREFIX}/lib/ocaml",
                          "--pkgdir=#{HOMEBREW_PREFIX}/lib/ocaml/camlp4"
    system "make", "all"
    system "make", "install"
  end
end
