require 'formula'

class Rebar < Formula
  homepage 'https://github.com/rebar/rebar'
  url 'https://github.com/rebar/rebar/archive/2.2.0.zip'
  sha1 '48e3b6e4293129b990c4e35dc0be5f822c66e08d'

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
