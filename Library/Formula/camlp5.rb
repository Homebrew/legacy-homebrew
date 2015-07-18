class Camlp5 < Formula
  desc "Camlp5 is a preprocessor and pretty-printer for OCaml"
  homepage "http://camlp5.gforge.inria.fr/"
  url "http://camlp5.gforge.inria.fr/distrib/src/camlp5-6.13.tgz"
  sha256 "d1e948c04079e417d2b616f03f57cda9b6111c563d7ce59a8956ac93772e4aa9"

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
