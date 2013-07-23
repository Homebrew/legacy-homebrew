require 'formula'

class Leiningen < Formula
  VERSION  = '2.2.0'
  LEIN_JAR = "#{ENV['HOME']}/.lein/self-installs/leiningen-#{VERSION}-standalone.jar"
  
  homepage 'https://github.com/technomancy/leiningen'
  url "https://github.com/technomancy/leiningen/archive/#{VERSION}.tar.gz"
  sha1 '0ca7e4ea68b490171d869bd5cc3912feba8d7ee9'

  head 'https://github.com/technomancy/leiningen.git'

  def install
    bin.install "bin/lein"
    system "#{bin}/lein", "self-install" unless File.exist?(LEIN_JAR)
    bash_completion.install 'bash_completion.bash' => 'lein-completion.bash'
    zsh_completion.install 'zsh_completion.zsh' => '_lein'
  end

  def caveats; <<-EOS.undent
    Standalone jar and dependencies installed to:
      $HOME/.m2/repository
    EOS
  end
end
