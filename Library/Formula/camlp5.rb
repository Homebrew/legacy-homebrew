require "formula"

class Camlp5 < Formula
  homepage "http://camlp5.gforge.inria.fr/"
  url "http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-6.12.tgz"
  sha1 "d78d89dbd33725d7589181c38cc67180502da2f8"
  revision 2

  bottle do
    revision 1
    sha1 "1b80d63b1cf8253d01cab351d41e785c52302e9b" => :yosemite
    sha1 "2caa1f1a2ede6630b04e3d8759f72654c60f2ff9" => :mavericks
    sha1 "b62f655ebc58631713c33be835e5004723cec314" => :mountain_lion
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
