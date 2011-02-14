require 'formula'

class Ninja <Formula
  head 'git://github.com/martine/ninja.git'
  homepage 'https://github.com/martine/ninja'
  md5 ''

  def install
    system "./bootstrap.sh"
    bin.mkpath
    bin.install "ninja"
  end
  
  def patches
    ["https://github.com/alexgartrell/ninja/commit/27e38cf5fbdf1b88831c64f053312eeb1f172d64.diff",
     "https://github.com/alexgartrell/ninja/commit/7c14d4d3b3e3abc2907037ede5131a221eca2ad3.diff"]
  end
end
