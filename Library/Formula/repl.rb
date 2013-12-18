require 'formula'

class Repl < Formula
  homepage 'https://github.com/defunkt/repl'
  url 'https://github.com/defunkt/repl/archive/v1.0.0.tar.gz'
  sha1 'd47d31856a0c474daf54707d1575b45f01ef5cda'

  depends_on 'rlwrap' => :optional

  def install
    bin.install 'bin/repl'
    man1.install 'man/repl.1'
  end
end
