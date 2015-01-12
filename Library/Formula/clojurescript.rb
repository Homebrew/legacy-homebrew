class Clojurescript < Formula
  homepage "https://github.com/clojure/clojurescript"
  head "https://github.com/clojure/clojurescript.git"
  url "https://github.com/clojure/clojurescript/archive/r2665.tar.gz"
  sha1 "364e799e9a4f2c79d1058ec10909a96071d1b5a3"

  bottle do
    cellar :any
    sha1 "a1e0a6ab52df6fc41697c5b669b0088a071fca94" => :yosemite
    sha1 "58e46c032fb6059f6ce1ebb54e1ec9eb4bb17183" => :mavericks
    sha1 "dd099b7132450b0458076e8eaa0db42ae2611ecc" => :mountain_lion
  end

  def install
    system "./script/bootstrap"
    inreplace %w(bin/cljsc script/repl script/repljs script/browser-repl),
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
