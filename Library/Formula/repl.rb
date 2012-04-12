require 'formula'

class Repl < Formula
  url 'https://github.com/defunkt/repl/tarball/v1.0.0'
  homepage 'https://github.com/defunkt/repl'
  md5 '755f121d1ae777a0e3c26f837d8fb18a'

  depends_on 'rlwrap' => :optional

  def install
    bin.install 'bin/repl'
    man1.install 'man/repl.1'
  end
end
