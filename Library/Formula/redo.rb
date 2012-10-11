require 'formula'

class RedoDocs < Formula
  head 'https://github.com/apenwarr/redo.git', :branch => 'man'
  version 'foo'
end

class Redo < Formula
  homepage 'https://github.com/apenwarr/redo'
  url "https://github.com/apenwarr/redo/tarball/redo-0.11"
  sha1 '013f1225c43b25e76b12707846321f2776d441fb'

  def install
    ENV['PREFIX'] = prefix
    system "./redo install"
    rm share+'doc/redo/README.md' # lets not have two copies

    RedoDocs.new('redodocs').brew do
      man1.install Dir['*']
    end
  end
end
