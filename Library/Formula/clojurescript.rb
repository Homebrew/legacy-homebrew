require 'formula'

class Clojurescript < Formula
  homepage 'https://github.com/clojure/clojurescript/wiki'
  url 'https://github.com/clojure/clojurescript/archive/r1552.tar.gz'
  version '1552'
  sha1 'b1d46005cfaf5edc941e9f19169401b63e4e1c44'

  def install
    system "sh ./script/bootstrap"
    prefix.install Dir['*']
  end

  def test
  end

  def caveats
    <<-EOS.undent
      Before you can use the ClojureScript compiler you must set the environment variable via:

      export CLOJURESCRIPT_HOME=#{prefix} 

      and restart your current terminal session.
      It is recommended to add line this to a file such as .bashrc or .bash_profile that 
      executes on terminal or user login
    EOS
  end
end
