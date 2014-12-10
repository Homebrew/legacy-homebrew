require 'formula'

class Redo < Formula
  homepage 'https://github.com/apenwarr/redo'
  url 'https://github.com/apenwarr/redo/archive/redo-0.11.tar.gz'
  sha1 'f9f939e599047d9dc7fdadacc3308c6722f3a512'

  resource 'docs' do
    url 'https://github.com/apenwarr/redo.git', :branch => 'man'
  end

  def install
    ENV['PREFIX'] = prefix
    system "./redo install"
    rm share/'doc/redo/README.md' # lets not have two copies
    man1.install resource('docs')
  end
end
