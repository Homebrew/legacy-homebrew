require 'formula'

class Elixir < Formula
  homepage 'http://elixir-lang.org/'
  url  'https://github.com/elixir-lang/elixir/archive/v0.10.2.tar.gz'
  sha1 'fd12cfc3d7ebba9087ea1d13de6ad940c644ecf1'

  head 'https://github.com/elixir-lang/elixir.git'

  depends_on 'erlang'

  def install
    system "make"
    bin.install Dir['bin/*'] - Dir['bin/*.bat']

    Dir['lib/*/ebin'].each do |path|
      app  = File.basename(File.dirname(path))
      (lib/"#{app}").install path
    end
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end
