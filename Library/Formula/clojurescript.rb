require "formula"

class Clojurescript < Formula
  homepage "https://github.com/clojure/clojurescript"
  head "https://github.com/clojure/clojurescript.git"
  url "https://github.com/clojure/clojurescript/archive/r2371.tar.gz"
  sha1 "63284f043f2f61adcc78de60998520b382b5f135"

  bottle do
    cellar :any
    sha1 "640fd5b5a0f0abf677663879e8ea7cf391613508" => :mavericks
    sha1 "63ae3b5f13dc4df3df767d4d0f67d2dd7eab14c4" => :mountain_lion
    sha1 "1c0671366c0ed5630fe7822464220d60737cc2f4" => :lion
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
    system "#{bin}/cljsc"
  end
end
