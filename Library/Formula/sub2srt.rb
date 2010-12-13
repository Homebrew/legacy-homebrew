require 'formula'

class Sub2srt <Formula
  url 'http://www.robelix.com/sub2srt/download/sub2srt-0.5.3.tar.gz'
  homepage 'http://www.robelix.com/sub2srt/'
  md5 'ce2dd86b008ab61b70cd1f2ed6054a4b'

  def install
    bin.install('sub2srt')
  end
end
