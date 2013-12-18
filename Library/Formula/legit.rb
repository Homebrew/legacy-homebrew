require 'formula'

class Legit < Formula
  homepage 'http://www.git-legit.org/'
  url 'https://github.com/downloads/kennethreitz/legit/legit-v0.1.0-darwin-x86.tar.bz2'
  version '0.1.0'
  sha1 'a2cdfb59ab949f14f23784cf6861a50da923f71b'

  def install
    bin.install 'legit'
  end
end
