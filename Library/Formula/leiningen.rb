require 'formula'

class Leiningen < Formula
  homepage 'https://github.com/technomancy/leiningen'
  url 'https://github.com/technomancy/leiningen/archive/2.3.4.tar.gz'
  sha1 '0fdccbc441237a1dde5dd16b5d9edb936c4a8c36'

  head 'https://github.com/technomancy/leiningen.git'

  resource 'jar' do
    url 'https://leiningen.s3.amazonaws.com/downloads/leiningen-2.3.4-standalone.jar'
    sha1 '59718bb8553f25b8ca853f57dd259cd81eb16f91'
  end

  def install
    libexec.install resource('jar')

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
