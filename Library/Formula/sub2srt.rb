require 'formula'

class Sub2srt < Formula
  homepage 'http://www.robelix.com/sub2srt/'
  url 'http://www.robelix.com/sub2srt/download/sub2srt-0.5.3.tar.gz'
  sha1 'eaecadc4caaaacddcd0e13202be722f13706acd4'

  def install
    bin.install 'sub2srt'
  end
end
