require 'formula'

class RedoDocs < Formula
  head 'https://github.com/apenwarr/redo.git', :branch => 'man'
  version 'foo'
end

class Redo < Formula
  homepage 'https://github.com/apenwarr/redo'
  url "https://github.com/apenwarr/redo/tarball/redo-0.11"
  md5 'c7090dbe2e731815e0201339ededc011'

  def install
    ENV['PREFIX'] = prefix
    system "./redo install"
    rm share+'doc/redo/README.md' # lets not have two copies

    RedoDocs.new('redodocs').brew do
      man1.install Dir['*']
    end
  end
end
