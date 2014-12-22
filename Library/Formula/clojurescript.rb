require "formula"

class Clojurescript < Formula
  homepage "https://github.com/clojure/clojurescript"
  head "https://github.com/clojure/clojurescript.git"
  url "https://github.com/clojure/clojurescript/archive/r2411.tar.gz"
  sha1 "99022cf050aa5f712b295e74aa8e845ad6cdb4b8"

  bottle do
    cellar :any
    sha1 "09c172126af27f251d97faf51bccec08701b02b4" => :yosemite
    sha1 "01b25ba53a056b9a5bbd895c69c8a9d7bb981ff8" => :mavericks
    sha1 "67852244cdfaaf0df84b8bcec440fe43fb719b6f" => :mountain_lion
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
