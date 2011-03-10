require 'formula'

class RedoDocs < Formula
  head 'https://github.com/apenwarr/redo.git', {:using => :git, :branch => 'man' }
  version 'foo'
end

class Redo < Formula
  version '0.06'
  url "https://github.com/apenwarr/redo/zipball/redo-#{version}"
  homepage 'https://github.com/apenwarr/redo'
  md5 '7af7d8a639943731bb0370427b55bf10'

  def install
    ENV['PREFIX'] = prefix
    system "./redo install"
    rm share/:doc/:redo/'README.md' # lets not have two copies

    RedoDocs.new('redodocs').brew do |formula|
      man1.install Dir['*']
    end
  end
end
