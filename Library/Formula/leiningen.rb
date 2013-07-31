require 'formula'

class LeiningenJar < Formula
  url 'https://leiningen.s3.amazonaws.com/downloads/leiningen-2.2.0-standalone.jar', :using => :nounzip
  sha1 '694c01251f71954e9d1d7003b42dee1b3a393191'
end

class Leiningen < Formula
  homepage 'https://github.com/technomancy/leiningen'
  url 'https://github.com/technomancy/leiningen/archive/2.2.0.tar.gz'
  sha1 '0ca7e4ea68b490171d869bd5cc3912feba8d7ee9'

  head 'https://github.com/technomancy/leiningen.git'

  def install
    LeiningenJar.new.brew { libexec.install 'leiningen-2.2.0-standalone.jar' }
    # bin/lein autoinstalls and autoupdates, which doesn't work too well for us
    inreplace "bin/lein-pkg" do |s|
      s.change_make_var! 'LEIN_JAR', libexec/'leiningen-2.2.0-standalone.jar'
    end
    bin.install "bin/lein-pkg" => 'lein'
    bash_completion.install 'bash_completion.bash' => 'lein-completion.bash'
    zsh_completion.install 'zsh_completion.zsh' => '_lein'
  end

  def caveats; <<-EOS.undent
    Dependencies will be installed to:
      $HOME/.m2/repository
    EOS
  end
end
