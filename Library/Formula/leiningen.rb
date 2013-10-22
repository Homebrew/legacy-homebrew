require 'formula'

class Leiningen < Formula
  homepage 'https://github.com/technomancy/leiningen'
  url 'https://github.com/technomancy/leiningen/archive/2.3.3.tar.gz'
  sha1 'af420542bbe6496a810355efedba00c9ba827ab2'

  head 'https://github.com/technomancy/leiningen.git'

  resource 'jar' do
    url 'https://leiningen.s3.amazonaws.com/downloads/leiningen-2.3.3-standalone.jar'
    sha1 'bd14a59581eb0799200f3a6f30534d685c6ad095'
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
