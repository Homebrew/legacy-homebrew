class Lfe < Formula
  desc "A Concurrent Lisp for the Erlang VM"
  homepage "http://lfe.io/"
  url "https://github.com/rvirding/lfe/archive/v1.0.tar.gz"
  sha256 "a335f593faf96fadbe9d049c5be5d331ba19628bd5dd41cedcbc62bb7c597fe7"

  head "https://github.com/rvirding/lfe.git", :branch => "develop"

  bottle do
    sha256 "8a6adf72bf5d51ec031aeccfeef5b3f07a829a959ef238f0a01e4d2cee3fb0b8" => :el_capitan
    sha256 "68bed24455801df91738dce5a0da2162d179e0b4569bb03a88bc468621d05b64" => :yosemite
    sha256 "63bbc993e6c35f61bed6376f1660ace93a08a59169e7fe907b7688d5bdf96808" => :mavericks
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
