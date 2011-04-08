require 'formula'

class Fluxus < Formula
  head 'git://git.savannah.nongnu.org/fluxus.git'
  homepage 'http://www.pawfal.org/fluxus/'

  depends_on 'scons' => :build

  depends_on 'plt-racket'
  depends_on 'libsndfile'
  depends_on 'glew'
  depends_on 'liblo'
  depends_on 'ode'
  depends_on 'jack'
  depends_on 'fftw'
  depends_on 'jpeg'
  depends_on 'libtiff'

  def install
    racket_prefix = Formula.factory("plt-racket").prefix
    system 'scons', "Prefix=#{prefix}", "RacketLib=#{racket_prefix}/lib/racket",
      "RacketCollects=#{racket_prefix}/lib/racket/collects",
      "RacketInclude=#{racket_prefix}/include/racket", "RACKET_FRAMEWORK=0", "ADDONS=0",
      "install"
  end
end
