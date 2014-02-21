require 'formula'

class Q < Formula
  homepage 'https://github.com/harelba/q'
  url 'https://github.com/harelba/q/archive/1.1.7.tar.gz'
  sha1 '088a4f267167481ae0c0825ad410c897aeaab9e8'

  def install
    bin.install 'q'
  end
end

