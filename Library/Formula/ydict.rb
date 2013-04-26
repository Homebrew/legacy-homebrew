require 'formula'

class Ydict < Formula
  homepage 'http://code.google.com/p/ydict/'
  url 'http://ydict.googlecode.com/files/ydict-1.2.6.tar.gz'
  sha1 '08eb840c31964fb80c5f9af54a26e2bd6e622d6b'

  def install
    bin.install 'ydict'
  end
  def caveats
    "Please set your LC_ALL to UTF-8, ex: 'export LC_ALL=en_US.UTF-8'"
  end
end
