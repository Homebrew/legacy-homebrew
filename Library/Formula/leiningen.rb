class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https://github.com/technomancy/leiningen"
  head "https://github.com/technomancy/leiningen.git"
  url "https://github.com/technomancy/leiningen/archive/2.5.2.tar.gz"
  sha256 "50cd21d718603bfa4b6da673696c60482271d310f67b98a794d0413a79121a9d"

  bottle do
    cellar :any
    sha256 "5c41d3bd528fc99d527d0061d13189d1d4a1b71727ae03e8963d375b007fb49c" => :yosemite
    sha256 "fbe674b4a26f6f3c9e23ec86707ae2e07489c1a287269650b592727e6ec167ec" => :mavericks
    sha256 "cb3fdfcf22220913a2222179f4cc220fbb1b6c04a0ba6f37f8750bacbbf7859a" => :mountain_lion
  end

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.5.2/leiningen-2.5.2-standalone.zip", :using => :nounzip
    sha256 "64c70202dc7989de1b9d8b8b9b99e87dbb7698338e24d25722777412e37e1b62"
  end

  def install
    jar = "leiningen-#{version}-standalone.jar"
    resource("jar").stage do
      libexec.install "leiningen-#{version}-standalone.zip" => jar
    end

    # bin/lein autoinstalls and autoupdates, which doesn't work too well for us
    inreplace "bin/lein-pkg" do |s|
      s.change_make_var! "LEIN_JAR", libexec/jar
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
                  [brew-test.core :as t]))
      (deftest canary-test
        (testing "adds-two yields 4 for input of 2"
          (is (= 4 (t/adds-two 2)))))
    EOS
    system "#{bin}/lein", "test"
  end
end
