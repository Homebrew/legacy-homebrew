require "formula"

class Cpansearch < Formula
  homepage "https://github.com/c9s/cpansearch"
  url "https://github.com/c9s/cpansearch/archive/0.2.tar.gz"
  sha1 "302638f78f2b09630cabd3975c38d5fc591c43e7"

  head "https://github.com/c9s/cpansearch.git"

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "make"
    bin.install "cpans"
  end

  def caveats; <<-EOS.undent
    For usage instructions:
        more #{opt_prefix}/README.md
    EOS
  end
end
