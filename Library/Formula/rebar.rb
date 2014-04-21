require 'formula'

class Rebar < Formula
  homepage 'https://github.com/rebar/rebar'
  url 'https://github.com/rebar/rebar/archive/2.2.0.tar.gz'
  sha1 '8b246586383d8809c7681f3e56bfc8d8c3b3757e'

  head "https://github.com/rebar/rebar.git", :branch => "master"

  depends_on 'erlang'

  def install
    system './bootstrap'
    bin.install 'rebar'
  end

  test do
    system 'rebar', '--version'
  end
end
