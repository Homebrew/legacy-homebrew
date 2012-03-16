require 'formula'

class NodeRequired < Requirement
  def message; <<-EOS.undent
    CoffeeScript rqeuires Node to be installed.
    You can install using Homebrew:
      brew install node

    If you are installing the --HEAD version of CoffeeScript,
    you may need the --HEAD version of node:
      brew install --HEAD node
    EOS
  end
  def satisfied?
    Formula.factory("node").installed? or which('node')
  end
  def fatal?
    true
  end
end

class CoffeeScript < Formula
  url 'http://github.com/jashkenas/coffee-script/tarball/1.2.0'
  head 'https://github.com/jashkenas/coffee-script.git'
  homepage 'http://jashkenas.github.com/coffee-script/'
  md5 '5dfc3ee21214f1b7e86c0535f5386a35'

  depends_on NodeRequired.new

  def install
    bin.mkpath
    system "./bin/cake", "--prefix", prefix, "install"
  end

  def caveats; <<-EOS.undent
    coffee-script can also be installed via npm with:
      npm install coffee-script

    This has the advantage of supporting multiple versions of Node libs
    at the same time.
    EOS
  end
end
