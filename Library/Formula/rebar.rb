require 'formula'

class Rebar < Formula
  homepage 'https://github.com/rebar/rebar'
  url 'https://github.com/rebar/rebar/archive/2.0.0.zip'
  sha1 '4775839097324107c730e094e42ce87b456b655c'

  depends_on 'erlang'

  def install
    system './bootstrap'
    bin.install 'rebar'
  end

  test do
    system 'rebar', '--version'
  end
end
