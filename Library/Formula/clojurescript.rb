class Clojurescript < Formula
  desc "Clojure to JS compiler"
  homepage "https://github.com/clojure/clojurescript"
  head "https://github.com/clojure/clojurescript.git"
  url "https://github.com/clojure/clojurescript/releases/download/r3308/cljs.jar", :using => :nounzip
  sha256 "8ec232b2d5660083cb3038bc6e0f509faee398af7c88d01fe7585f68dd3eeac6"
  version "r3308"

  bottle do
    cellar :any
    sha1 "aa8b2bd64da090c12d508e63bbf56a5128abfbcf" => :yosemite
    sha1 "f56c2dfcd8ee828a2734ea1c39c6c1f1c147178b" => :mavericks
    sha1 "63127cb547b78d3a7fac2770fe3ed56ce39acc10" => :mountain_lion
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
