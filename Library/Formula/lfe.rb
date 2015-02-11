class Lfe < Formula
  homepage "http://lfe.io/"
  url "https://github.com/rvirding/lfe/archive/v0.9.1.tar.gz"
  sha1 "015c23e7c761c2ccfefb7a9f97f85fe09f1cd648"

  head "https://github.com/rvirding/lfe.git", :branch => "develop"

  depends_on "erlang"
  depends_on "rebar"

  def install
    system "rebar", "compile"
    bin.install Dir["bin/*"]
    prefix.install "ebin"
  end

  test do
    system bin/"lfe", "-eval", "'(io:format \"42\")'"
  end
end
