require 'formula'

class Z <Formula
  head 'git://github.com/rupa/z.git'
  homepage 'https://github.com/rupa/z'

  def install
    bin.install('z.sh')
    man1.mkpath
    man1.install('z.1')
  end
end
