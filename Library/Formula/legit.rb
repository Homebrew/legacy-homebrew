require 'formula'

class Legit < Formula
  homepage 'http://www.git-legit.org/'

  url 'https://github.com/downloads/kennethreitz/legit/legit-v0.1.0-darwin-x86.tar.bz2'
  version '0.1.0'
  md5 '8e9e48ae8ff779e1c79a9b12c0d6508c'

  skip_clean :all

  def install
    bin.install 'legit'
  end
end
