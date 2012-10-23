require 'formula'

class Shmcat < Formula
  homepage 'http://shmcat.sourceforge.net/'
  url 'http://heanet.dl.sourceforge.net/project/shmcat/shmcat-1.5.tar.bz2'
  version '1.5'
  sha1 'ab0aa596eccfc0343f5863cc4ceb874f91ad9d09'

  depends_on 'gettext' if build.include? 'with-nls'

  option 'with-ftok', "Build the ftok utility"
  option 'with-nls', "Use Native Language Support"

  def install
    gettext = Formula.factory('gettext')

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--disable-ftok" unless build.include? 'with-ftok'
    if build.include? 'with-nls'
      args << "--with-libintl-prefix=#{gettext.include}"
    else
      args << "--disable-nls"
    end

    system "./configure", *args

    system "make install"
  end

  def test
    system "false"
  end
end
