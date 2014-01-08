require 'formula'

class Q < Formula
  homepage 'https://github.com/harelba/q'
  url 'https://github.com/harelba/q/archive/1.1.1.tar.gz'
  sha1 'c41645b32ff618a03dd925aee8a497de2fe4721d'

  def install
    bin.install 'q'
  end
end

