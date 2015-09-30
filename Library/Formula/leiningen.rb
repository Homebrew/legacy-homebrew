class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https://github.com/technomancy/leiningen"
  head "https://github.com/technomancy/leiningen.git"
  url "https://github.com/technomancy/leiningen/archive/2.5.3.tar.gz"
  sha256 "e44db1e021937a6aa68635960aefe581bf4a4090f4a0e159f6a14904d8f9e9ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9ae85b9043633b6a556b3772d6ee94f07560121f0d8bf5b5c71256aa44a31fc" => :el_capitan
    sha256 "eda66e38c1a262def28404faa43012b99dc0d0bb7271bfce34d592d9b4819a97" => :yosemite
    sha256 "466006f676de0d2bad06139b7048484e0e681143f211188c80d82f5ffe17cbbc" => :mavericks
  end

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.5.3/leiningen-2.5.3-standalone.zip", :using => :nounzip
    sha256 "4b0c1606b6a4816b803f1fbd704aeefc9d6e314e9b9a482d0bae0ab0079023dd"
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
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{ENV["HOME"]}"
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
