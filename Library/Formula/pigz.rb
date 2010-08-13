require 'formula'

class Pigz <Formula
  url 'http://www.zlib.net/pigz/pigz-2.1.6.tar.gz'
  homepage 'http://www.zlib.net/pigz/'
  md5 'cbe9030c4be3d0ef2438ee5f8b169ca4'

  def install
    system "make"
    bin.install ["pigz", "unpigz"]
  end
end
