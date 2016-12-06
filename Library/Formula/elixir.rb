require 'formula'

class Elixir < Formula
  version '0.3.0'
  head 'https://github.com/josevalim/elixir.git', :tag => 'v0.3.0'
  homepage 'https://github.com/josevalim/elixir'

  depends_on 'erlang'

  def install
    bin.install Dir['bin/*']
  end
end
