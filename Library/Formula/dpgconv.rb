require 'formula'

class Dpgconv < Formula
  url 'http://pypi.python.org/packages/source/d/dpgconv/dpgconv-10.1.tar.gz'
  homepage 'http://theli.is-a-geek.org/blog/static/dpgconv'
  md5 '1a0462e326d69d9beabde60ed5a4e9b2'

  depends_on 'pil'
  depends_on 'mplayer'
  depends_on 'mpeg_stat'

  def install
    system "python setup.py install --prefix=#{prefix}"
  end
end
