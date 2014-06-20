require "formula"

class Camlp5 < Formula
  homepage "http://camlp5.gforge.inria.fr/"
  url "http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-6.11.tgz"
  sha1 "4649a2850869d624182bfb5a02f60800ae35b935"

  depends_on "objective-caml"

  option "strict", "Compile in strict mode"

  def install
    if build.include? "strict"
      strictness = "-strict"
    else
      strictness = "-transitional"
    end

    system "./configure", "-prefix", prefix, "-mandir", man, strictness
    # this build fails if jobs are parallelized
    ENV.deparallelize
    system "make", "world.opt"
    system "make", "install"
  end
end
