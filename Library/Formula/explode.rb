require 'formula'

class Explode < Formula
  url 'https://github.com/mrman208/explode/tarball/master'
  homepage 'https://github.com/mrman208/explode'
  md5 '35f164e0c686b85168bf76401f5e8074'
  version '1.2'

  def install
    system "mv explode.sh explode"
  end
end
