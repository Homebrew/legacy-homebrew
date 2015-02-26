class Clojurescript < Formula
  homepage "https://github.com/clojure/clojurescript"
  head "https://github.com/clojure/clojurescript.git"
  url "https://github.com/clojure/clojurescript/archive/r2913.tar.gz"
  sha1 "ff33a93516b3c91923667d667d34cc4b404489c8"

  bottle do
    cellar :any
    sha1 "28b50ad7793132d46dbec7821243b8e0cad332ed" => :yosemite
    sha1 "6ad254ec5f8ab2e66de53dbf6240ff29703a6c1b" => :mavericks
    sha1 "b090510a461c9e1274590e2840640c2195f9969e" => :mountain_lion
  end

  def install
    system "./script/bootstrap"
    inreplace %w[bin/cljsc script/repl script/repljs script/browser-repl],
      "#!/bin/sh", "#!/bin/sh\nCLOJURESCRIPT_HOME=#{libexec}"
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/cljsc"
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
