require 'formula'

class Repl < Formula
  url 'http://github.com/defunkt/repl/tarball/v0.2.1'
  homepage 'http://github.com/defunkt/repl'
  md5 '5b9d43038f1b561bd3215a01ee3cb766'

  depends_on 'rlwrap' => :optional

  def install
    bin.install 'bin/repl'
    man1.install 'man/repl.1'
  end
end
