require 'formula'

class Synfig < Formula
  url 'https://downloads.sourceforge.net/project/synfig/synfig/0.63.02/synfig-0.63.02.tar.gz'
  homepage 'http://synfig.org'
  md5 '4286d5e1887275107d760d1b678aec24'

  head 'git://synfig.git.sourceforge.net/gitroot/synfig/synfig', :using => :git

  def patches
    # this patches synfig to work with libpng 1.5 per http://sourceforge.net/tracker/?func=detail&aid=3427945&group_id=144022&atid=757416
    { :p2 => "http://sourceforge.net/tracker/download.php?group_id=144022&atid=757416&file_id=426842&aid=3427945" }
  end

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'etl'
  depends_on 'libsigc++'
  depends_on 'libxml++'
  depends_on 'imagemagick'

  def install
    ENV.libpng
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
