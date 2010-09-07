require 'formula'

class Camlp5 <Formula
  url 'http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-5.15.tgz'
  homepage 'http://pauillac.inria.fr/~ddr/camlp5/'
  md5 '67ccbf37ffe33dec137ee71ca6189ea2'

  depends_on 'objective-caml'

  def install
    system "./configure -strict -prefix #{prefix} -mandir #{man}"
    # this build fails if jobs are parallelized
    system "make -j 1 world.opt"
    system "make install"
  end
end
