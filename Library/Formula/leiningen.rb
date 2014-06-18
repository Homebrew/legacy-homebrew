require 'formula'

class Leiningen < Formula
  homepage 'https://github.com/technomancy/leiningen'
  url 'https://github.com/technomancy/leiningen/archive/2.4.2.tar.gz'
  sha1 '1b8ad13023c23128b47972b8d386e83f3c04f3f0'

  head 'https://github.com/technomancy/leiningen.git'

  resource 'jar' do
    url 'https://github.com/technomancy/leiningen/releases/download/2.4.2/leiningen-2.4.2-standalone.jar'
    sha1 'cd1e649178ab625a773a9dfa51456df5c352960c'
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

  test do
    (testpath/'project.clj').write <<-EOS.undent
      (defproject brew-test "1.0"
        :dependencies [[org.clojure/clojure "1.5.1"]])
    EOS
    (testpath/'src/brew_test/core.clj').write <<-EOS.undent
      (ns brew-test.core)
        (defn adds-two
          "I add two to a number"
          [x]
          (+ x 2))
    EOS
    (testpath/'test/brew_test/core_test.clj').write <<-EOS.undent
      (ns brew-test.core-test
        (:require [clojure.test :refer :all]
                  [brew-test.core :refer :all]))
      (deftest canary-test
        (testing "adds-two yields 4 for input of 2"
          (is (= 4 (adds-two 2)))))
    EOS
    system "#{bin}/lein", 'test'
  end

end
