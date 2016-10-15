require 'formula'

class Justrun < Formula
  homepage 'http://github.com/jmhodges/justrun/#readme'
  url 'http://projects.somethingsimilar.com/justrun/downloads/justrun-1.0.0-osx_amd64.zip'
  sha1 '811e7f6bf44fc1fa8ef0ef48bba3a2b28bcbac29'
  version '1.0.0'

  def install
    bin.install 'justrun'
  end
end
