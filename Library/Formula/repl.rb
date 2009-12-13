require 'formula'

class Repl < Formula
  head 'git://github.com/defunkt/repl.git', :tag => 'v0.1.0'
  homepage 'http://github.com/defunkt/repl'

  def initialize(*args)
    super
    @version = '0.1.0'
  end

  def install
    bin.install 'bin/repl'
    man1.install 'man/repl.1'
  end
end
