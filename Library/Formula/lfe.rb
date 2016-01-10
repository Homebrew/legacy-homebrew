class Lfe < Formula
  desc "A Concurrent Lisp for the Erlang VM"
  homepage "http://lfe.io/"
  url "https://github.com/rvirding/lfe/archive/v0.10.0.tar.gz"
  sha256 "656e977c2aa5cce3a64a85d415e3b2d72111e03c3b954fc113051207748ecf19"

  head "https://github.com/rvirding/lfe.git", :branch => "develop"

  bottle do
    sha256 "abab2b90fd859e6832ba17879a549631b0ce195112124ee666fe2c3a86cadbc1" => :el_capitan
    sha256 "c6431da9f7733862f4d38936f4b8d4e8a0227a110f3d477d7b11fe25402af3cb" => :yosemite
    sha256 "605f38f780ad9f6d0665463a03805aea9472ca0e4ef60f567236cbcb572cb105" => :mavericks
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
