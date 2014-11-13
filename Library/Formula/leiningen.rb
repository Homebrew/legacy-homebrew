require "formula"

class Leiningen < Formula
  homepage "https://github.com/technomancy/leiningen"
  head "https://github.com/technomancy/leiningen.git"
  url "https://github.com/technomancy/leiningen/archive/2.5.0.tar.gz"
  sha1 "881c3646c41d9aea14f5401981d45053483125bc"

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.5.0/leiningen-2.5.0-standalone.jar"
    sha1 "7514d137f0f4ff226c0171df47a3422b1ecfa80a"
  end

  def install
    libexec.install resource("jar")

    # bin/lein autoinstalls and autoupdates, which doesn't work too well for us
    inreplace "bin/lein-pkg" do |s|
      s.change_make_var! "LEIN_JAR", libexec/"leiningen-#{version}-standalone.jar"
    end

    bin.install "bin/lein-pkg" => "lein"
    bash_completion.install "bash_completion.bash" => "lein-completion.bash"
    zsh_completion.install "zsh_completion.zsh" => "_lein"
  end

  def caveats; <<-EOS.undent
    Dependencies will be installed to:
      $HOME/.m2/repository
    To play around with Clojure run `lein repl` or `lein help`.
    EOS
  end

  test do
    (testpath/"project.clj").write <<-EOS.undent
      (defproject brew-test "1.0"
        :dependencies [[org.clojure/clojure "1.5.1"]])
    EOS
    (testpath/"src/brew_test/core.clj").write <<-EOS.undent
      (ns brew-test.core)
        (defn adds-two
          "I add two to a number"
          [x]
          (+ x 2))
    EOS
    (testpath/"test/brew_test/core_test.clj").write <<-EOS.undent
      (ns brew-test.core-test
        (:require [clojure.test :refer :all]
                  [brew-test.core :refer :all]))
      (deftest canary-test
        (testing "adds-two yields 4 for input of 2"
          (is (= 4 (adds-two 2)))))
    EOS
    system "#{bin}/lein", "test"
  end

end
