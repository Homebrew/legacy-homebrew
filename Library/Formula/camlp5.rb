require 'formula'

class Camlp5 < Formula
  homepage 'http://pauillac.inria.fr/~ddr/camlp5/'
  url 'http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-6.06.tgz'
  sha1 'd3d56748de424afc3f878e650254b9d3e5fae6c2'

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
