class Clojurescript < Formula
  desc "Clojure to JS compiler"
  homepage "https://github.com/clojure/clojurescript"
  head "https://github.com/clojure/clojurescript.git"
  url "https://github.com/clojure/clojurescript/releases/download/r3308/cljs.jar", :using => :nounzip
  sha256 "8ec232b2d5660083cb3038bc6e0f509faee398af7c88d01fe7585f68dd3eeac6"
  version "r3308"

  bottle do
    cellar :any
    sha256 "523451b9de06fc49ab0f7a6e2193c105d5ba12fa6e22268c114bfb2afe40bf59" => :yosemite
    sha256 "d3105232788d6000b37d229ceba4cb872891a78f01b307baf232a7adb6613bbb" => :mavericks
    sha256 "ce2f3e9931c789cff5dd217432b08167cdfd4670879d597ef2f1d1bab4dcead0" => :mountain_lion
  end

  def install
    mv "cljs.jar", "cljs-#{version}.jar"
    libexec.install "cljs-#{version}.jar"
    bin.write_jar_script libexec/"cljs-#{version}.jar", "cljsc"
  end

  def caveats; <<-EOS.undent
    This formula is useful if you need to use the ClojureScript compiler directly.
    For a more integrated workflow, Leiningen with lein-cljsbuild is recommended.
    EOS
  end

  test do
    (testpath/"t.cljs").write <<-EOF.undent
    (ns hello)
    (defn ^:export greet [n]
      (str "Hello " n))
    EOF

    system "#{bin}/cljsc", testpath/"t.cljs"
  end
end
