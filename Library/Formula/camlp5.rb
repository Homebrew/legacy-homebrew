require "formula"

class Camlp5 < Formula
  homepage "http://camlp5.gforge.inria.fr/"
  url "http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-6.12.tgz"
  sha1 "d78d89dbd33725d7589181c38cc67180502da2f8"

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
