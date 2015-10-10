class Lfe < Formula
  desc "A Concurrent Lisp for the Erlang VM"
  homepage "http://lfe.io/"
  url "https://github.com/rvirding/lfe/archive/v0.10.0.tar.gz"
  sha256 "656e977c2aa5cce3a64a85d415e3b2d72111e03c3b954fc113051207748ecf19"

  head "https://github.com/rvirding/lfe.git", :branch => "develop"

  bottle do
    sha256 "5e0da3e1633d5e289c9a92a684318a286dd97a417b4592bc7df34f470a1a0226" => :yosemite
    sha256 "b6f986960df221080a22fba8f7f54d19a1122dbe52a6824c076ad896638fb188" => :mavericks
    sha256 "26b4045d18d3a12945ac308b81e7a2755bd0c1a8f17e37056ec4f77daf042a4f" => :mountain_lion
  end

  depends_on "erlang"
  depends_on "rebar"

  def install
    system "rebar", "compile"
    bin.install Dir["bin/*"]
    prefix.install "ebin"
  end

  test do
    system bin/"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+/2 0 (lists:seq 1 6)))))"'
  end
end
