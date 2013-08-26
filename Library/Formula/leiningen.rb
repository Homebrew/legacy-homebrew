require 'formula'

class LeiningenJar < Formula
  url 'https://leiningen.s3.amazonaws.com/downloads/leiningen-2.3.2-standalone.jar'
  sha1 'ed6f93be75c796408544042cfd26699d45b49725'
end

class Leiningen < Formula
  homepage 'https://github.com/technomancy/leiningen'
  url 'https://github.com/technomancy/leiningen/archive/2.3.2.tar.gz'
  sha1 '08e56a44f137a2ebc69edb6d672f3446672d1c22'

  head 'https://github.com/technomancy/leiningen.git'

  def install
    LeiningenJar.new.brew { libexec.install "leiningen-#{version}-standalone.jar" }
    # bin/lein autoinstalls and autoupdates, which doesn't work too well for us
    inreplace "bin/lein-pkg" do |s|
      s.change_make_var! 'LEIN_JAR', libexec/"leiningen-#{version}-standalone.jar"
    end
    bin.install "bin/lein-pkg" => 'lein'
    bash_completion.install 'bash_completion.bash' => 'lein-completion.bash'
    zsh_completion.install 'zsh_completion.zsh' => '_lein'
  end

  def caveats; <<-EOS.undent
    Dependencies will be installed to:
      $HOME/.m2/repository
    To play around with Clojure run `lein repl` or `lein help`.
    EOS
  end
end
