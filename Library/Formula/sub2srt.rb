require 'formula'

class Sub2srt < Formula
  homepage 'https://github.com/robelix/sub2srt'
  url 'https://github.com/robelix/sub2srt/archive/0.5.4.tar.gz'
  sha1 '2aaaae905223b924a05978b3c52cad73d06828cc'

  def install
    bin.install 'sub2srt'
  end
end
