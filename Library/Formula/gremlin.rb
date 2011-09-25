require 'formula'

class Gremlin < Formula
  url 'https://github.com/downloads/tinkerpop/gremlin/gremlin-1.3.zip'
  homepage 'http://gremlin.tinkerpop.com/'
  md5 'c524ee20e119c3b6059cfd0b7873d94c'

  def install
    target = Pathname.new("target/gremlin-#{@version}-standalone")
    libexec.install Dir[target+'lib'+'*.jar']
    inreplace target+'bin'+'gremlin.sh', '`dirname $0`/../lib', libexec
    bin.install target+'bin'+'gremlin.sh' => 'gremlin'
  end
end
