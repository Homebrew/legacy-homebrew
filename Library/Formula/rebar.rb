require 'formula'

class Rebar < Formula
  homepage 'https://github.com/rebar/rebar'
  url 'https://github.com/rebar/rebar/archive/2.1.0.zip'
  sha1 '4137e2b8fb4fc9fb7fb0c75dc9fc8c908f8393b1'

  head "https://github.com/basho/rebar.git", :branch => "master"

  depends_on 'erlang'

  def install
    system './bootstrap'
    bin.install 'rebar'
  end

  test do
    system 'rebar', '--version'
  end
end
