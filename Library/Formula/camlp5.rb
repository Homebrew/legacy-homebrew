require "formula"

class Camlp5 < Formula
  homepage "http://camlp5.gforge.inria.fr/"
  url "http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-6.12.tgz"
  sha1 "d78d89dbd33725d7589181c38cc67180502da2f8"
  revision 2

  bottle do
    sha1 "a59c46767de8e867733609b08630953c57523fb3" => :yosemite
    sha1 "02c88c2b521f13d7733630f19c2fc145e6cb2d97" => :mavericks
    sha1 "73d8bd3f7848902360e171b425a8e807a512d449" => :mountain_lion
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
