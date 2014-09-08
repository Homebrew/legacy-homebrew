require "formula"

class Clojurescript < Formula
  homepage "https://github.com/clojure/clojurescript"
  head "https://github.com/clojure/clojurescript.git"
  url "https://github.com/clojure/clojurescript/archive/r2311.tar.gz"
  sha1 "dfce06b02f8e89ab60cd87d02d7092c30ec1f362"

  bottle do
    cellar :any
    sha1 "4dc103c7f1e1216affa15c1ccc73eca82731df6c" => :mavericks
    sha1 "9796fa561d4b13830a7a7384a24599c0a0219bb1" => :mountain_lion
    sha1 "58c0a3d966e36819c85593b19c338886d71dd3cc" => :lion
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
