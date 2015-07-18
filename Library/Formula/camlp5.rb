class Camlp5 < Formula
  desc "Camlp5 is a preprocessor and pretty-printer for OCaml"
  homepage "http://camlp5.gforge.inria.fr/"
  url "http://camlp5.gforge.inria.fr/distrib/src/camlp5-6.13.tgz"
  sha256 "d1e948c04079e417d2b616f03f57cda9b6111c563d7ce59a8956ac93772e4aa9"

  bottle do
    sha256 "aa844f23752518cdfceba1513388c90b273a78219f1b671809791acebe71fb87" => :yosemite
    sha256 "de39f4abfd0f57a73d6d45850bd8e3b82f78e25f217649b51b4bc32b0df65df4" => :mavericks
    sha256 "c5f5d96059f168aee1c86ea8c47789e27bc542baefa351eed463cb3f9c605df5" => :mountain_lion
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
