require 'formula'

class Camlp5 < Formula
  homepage 'http://pauillac.inria.fr/~ddr/camlp5/'
  url 'http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-6.09.tgz'
  sha1 '0a4d96d5560e2e073f2fcb9e58914e424de00fc6'
  version '6.09'

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
