require 'formula'

class Camlp5 < Formula
  homepage 'http://pauillac.inria.fr/~ddr/camlp5/'
  url 'http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-6.10.tgz'
  sha1 '5ed27b584a1d2e02f539264af48f75b952caec85'

  depends_on 'objective-caml'

  option 'strict', 'Compile in strict mode'

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
