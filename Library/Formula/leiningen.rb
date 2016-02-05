class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https://github.com/technomancy/leiningen"
  head "https://github.com/technomancy/leiningen.git"
  url "https://github.com/technomancy/leiningen/archive/2.6.0.tar.gz"
  sha256 "8689eed26ad841acd00e1286e9c3c54f9eaa6ff4e7d8acd5e75ed19b9df31057"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a37c69a352a48ac72a5d2843bc183634c24e78a582619f428d0452fbdbc865f" => :el_capitan
    sha256 "c98df35c777b8fae26acfb52ed24282328a0423ed57cce4c8f7c3c9c43c51ecc" => :yosemite
    sha256 "49b571649e3f70e928392a2588a37df6797592250592e60dee43f53b836b8fa8" => :mavericks
  end

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.6.0/leiningen-2.6.0-standalone.zip", :using => :nounzip
    sha256 "a643c547b6ed9d11dfc43188c48bae4180cfb047e65ee5335ec9bf77285514fc"
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
    ENV.java_cache

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
