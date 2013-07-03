require 'formula'

class RedoDocs < Formula
  head 'https://github.com/apenwarr/redo.git', :branch => 'man'
  version 'foo'
end

class Redo < Formula
  homepage 'https://github.com/apenwarr/redo'
  url "https://github.com/apenwarr/redo/archive/redo-0.11.tar.gz"
  sha1 '8b26d7c694b91a85d3f252e4ad85ca740ff0babd'

  def install
    ENV['PREFIX'] = prefix
    system "./redo install"
    rm share+'doc/redo/README.md' # lets not have two copies

    RedoDocs.new('redodocs').brew do
      man1.install Dir['*']
    end
  end
end
