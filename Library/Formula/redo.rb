require 'formula'

class RedoDocs < Formula
  head 'https://github.com/apenwarr/redo.git', {:using => :git, :branch => 'man' }
  version 'foo'
end

class Redo < Formula
  url "https://github.com/apenwarr/redo/zipball/redo-0.10"
  homepage 'https://github.com/apenwarr/redo'
  md5 '69b31b105db347968ee9486342fb6c1d'

  def install
    ENV['PREFIX'] = prefix
    system "./redo install"
    rm share/:doc/:redo/'README.md' # lets not have two copies

    RedoDocs.new('redodocs').brew do |formula|
      man1.install Dir['*']
    end
  end
end
