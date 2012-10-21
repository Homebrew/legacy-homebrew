require 'formula'

class Camlp5 < Formula
  homepage 'http://pauillac.inria.fr/~ddr/camlp5/'
  url 'http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-6.07.tgz'
  sha1 'a6b52e533e7062845a0a45dda097cb2eff52b928'
  version '6.07-1'

  depends_on 'objective-caml'

  option 'strict', 'Compile in strict mode'

  def patches
    { :p0 => "http://pauillac.inria.fr/~ddr/camlp5/distrib/src/patch-6.07-1" }
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
