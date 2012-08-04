require 'formula'

class Fasd < Formula
  homepage 'https://github.com/clvv/fasd'
<<<<<<< HEAD
  url 'https://github.com/clvv/fasd/tarball/0.7.1'
  sha1 '73c0c612e7e21d440636cc280b3dd64b33772af2'
=======
  url 'https://github.com/clvv/fasd/tarball/1.0.0'
  sha1 '4e8e39ea8847d8d9402634c60b6c4fbf461e71dd'
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a

  def install
    bin.install 'fasd'
    man1.install 'fasd.1'
  end
end
