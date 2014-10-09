require "formula"

class Camlp5 < Formula
  homepage "http://camlp5.gforge.inria.fr/"
  url "http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-6.12.tgz"
  sha1 "d78d89dbd33725d7589181c38cc67180502da2f8"

  bottle do
    sha1 "a96b54c869d6a746d63f4fae548eabce16e866e4" => :mavericks
    sha1 "865a5f4e5162ddbd661f930717f4e7d35b6dffb2" => :mountain_lion
    sha1 "ae8b490cad902abac671e9ac332dadd8a8e8cfe8" => :lion
  end

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
