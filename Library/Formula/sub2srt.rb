require 'formula'

class Sub2srt < Formula
  homepage 'https://github.com/robelix/sub2srt'
  url 'https://github.com/robelix/sub2srt/archive/0.5.3.tar.gz'
  sha1 'd0d1ed31adde5f3e6f117ca4e5a80b206d92b93f'

  def install
    bin.install 'sub2srt'
  end
end
