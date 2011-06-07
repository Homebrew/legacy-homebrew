require 'formula'

class Smush <Formula
  homepage 'https://github.com/thebeansgroup/smush.py'
  head 'git://github.com/thebeansgroup/smush.py.git'
  version '37d714402bf7d76a0d8c'

  depends_on 'python'
  depends_on 'gifsicle'
  depends_on 'imagemagick'
  depends_on 'pngcrush'
  depends_on 'jpeg'
  depends_on 'pngnq'

  def install
    bin.install 'smush.py'
    bin.install 'optimiser'
  end
end
