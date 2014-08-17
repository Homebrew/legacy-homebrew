require "formula"

class Relx < Formula
  homepage "https://github.com/erlware/relx"
  url "https://github.com/erlware/relx/archive/v1.0.4.tar.gz"
  sha1 "8f333cbee2074a9afd90f1845a56e99cd197dbf0"

  head "https://github.com/erlware/relx", :branch => "master"

  depends_on "erlang"
  depends_on "rebar"

  def install
    system "make"
    bin.install "relx"
  end

  test do
    system "relx", "--version"
  end
end
