require 'formula'

class Camlp5 < Formula
  homepage 'http://pauillac.inria.fr/~ddr/camlp5/'
  url 'http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-6.08.tgz'
  sha1 '6cdfc29a9bd23dcee7775996ac29f2a457119d4b'
  version '6.08-1'

  depends_on 'objective-caml'

  option 'strict', 'Compile in strict mode'

  def patches
    { :p0 => "http://pauillac.inria.fr/~ddr/camlp5/distrib/src/patch-6.08-1" }
  end

  def install
    if build.include? 'strict'
      strictness = "-strict"
    else
      strictness = "-transitional"
    end

    system "./configure", "-prefix", prefix, "-mandir", man, strictness
    # this build fails if jobs are parallelized
    ENV.deparallelize
    system "make world.opt"
    system "make install"
  end
end
