require 'formula'

class Vcodex < Formula
  homepage 'http://www2.research.att.com/~astopen/download/ref/vcodex/vcodex.html'
  url 'http://www2.research.att.com/~astopen/download/tgz/vcodex.2013-05-31.tgz',
    :user => "I accept www.opensource.org/licenses/eclipse:."
  sha1 '0423ee95b13069dd617c5f7625484a92d5068ea0'
  version '2013-05-31'

  def install
    # Vcodex makefiles do not work in parallel mode
    ENV.deparallelize
    # make all Vcodex stuff
    system "/bin/sh ./Runmake"
    # install manually
    bin.install Dir['bin/vc*']
    # put all includes into a directory of their own
    (include + "vcodex").install Dir['include/*.h']
    lib.install Dir['lib/*.a']
    man.install 'man/man3'
  end

  def caveats; <<-EOS.undent
    We agreed to the Eclipse Public License 1.0 for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end
