require 'formula'

class RedoDocs <Formula
  head 'https://github.com/apenwarr/redo.git', {:using => :git, :branch => 'man' }
  version 'foo'
end

class Redo <Formula
  version '0.05'
  url "https://github.com/apenwarr/redo/zipball/redo-#{version}"
  homepage 'https://github.com/apenwarr/redo'
  md5 'e96fe6dbdb75f8512a2ebf62b064186b'

  def install
    ENV['PREFIX'] = prefix
    system "./redo install"
    rm share/:doc/:redo/'README.md' # lets not have two copies

    RedoDocs.new('redodocs').brew do |formula|
      man1.install Dir['*']
    end
  end
end
