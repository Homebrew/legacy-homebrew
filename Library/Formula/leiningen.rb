require 'formula'

class Leiningen <Formula
  url 'http://github.com/technomancy/leiningen/tarball/1.2.0'
  head 'http://github.com/technomancy/leiningen.git', :using => :git
  homepage 'http://github.com/technomancy/leiningen'
  md5 '1d44ca19dacd67f65247c4e946c5916a'

  def install
    bin.install "bin/lein"
    system "#{bin}/lein self-install"

    # Install the lein bash completion file
    (etc+'bash_completion.d').install 'bash_completion.bash' => 'lein-completion.bash'
  end

  def caveats; <<-EOS.undent
    Standalone jar and dependencies installed to:
      $HOME/.m2/repository
    EOS
  end
end
