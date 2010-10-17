require 'formula'

class Fluxus <Formula
  head 'git://git.savannah.nongnu.org/fluxus.git', :branch => 'master'
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

  def patches
    # fix SCons build - fluxus assumes binary install of plt-racket by default
    "http://gist.github.com/raw/631352/fluxus_homebrew.patch"
  end

  def install
    racket_prefix = Formula.factory("plt-racket").prefix
    system "scons RacketPrefix=#{racket_prefix} Prefix=#{prefix} install"
  end
end
