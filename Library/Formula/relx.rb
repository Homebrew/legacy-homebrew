class Relx < Formula
  desc "Sane, simple release creation for Erlang"
  homepage "https://github.com/erlware/relx"
  url "https://github.com/erlware/relx/archive/v3.5.0.tar.gz"
  sha256 "60d7252369325c4a1146bc443383df2692afa885ffe10c6def20e5aefcb142ff"

  depends_on "erlang"

  def install
    system "./rebar3", "update"
    system "./rebar3", "escriptize"
    bin.install "_build/default/bin/relx"
  end

  test do
    system "#{bin}/relx", "--version"
  end
end
