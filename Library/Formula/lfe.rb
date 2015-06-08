class Lfe < Formula
  desc "LISP syntax front-end to the Erlang compiler"
  homepage "http://lfe.io/"
  url "https://github.com/rvirding/lfe/archive/v0.9.1.tar.gz"
  sha1 "015c23e7c761c2ccfefb7a9f97f85fe09f1cd648"

  head "https://github.com/rvirding/lfe.git", :branch => "develop"

  bottle do
    sha1 "7b297fcd87472e51a9bbaa996bf87de9ebd3c3d6" => :yosemite
    sha1 "3b04cf153041bf79eb49218f8006fe2c7a998fa6" => :mavericks
    sha1 "4fd64b920713e4f5af36fedd04fc9b840e0280cb" => :mountain_lion
  end

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
