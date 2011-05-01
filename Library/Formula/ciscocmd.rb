require 'formula'

class Ciscocmd <Formula
  url 'http://sourceforge.net/projects/cosi-nms/files/ciscocmd/ciscocmd-1.5/ciscocmd-1.5.tgz'
  homepage 'http://cosi-nms.sourceforge.net/'
  md5 '3189f82c601d62a94112bc0eeecdc30f'

  def install
    bin.install ['ciscocmd']
    man1.install ['ciscocmd.1']
  end
end
