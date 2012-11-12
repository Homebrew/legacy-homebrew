require 'formula'

class Shmcat < Formula
  homepage 'http://shmcat.sourceforge.net/'
  url 'http://heanet.dl.sourceforge.net/project/shmcat/shmcat-1.5.tar.bz2'
  sha1 'ab0aa596eccfc0343f5863cc4ceb874f91ad9d09'

  option 'with-ftok', "Build the ftok utility"
  option 'with-nls', "Use Native Language Support"

  depends_on 'gettext' if build.include? 'with-nls'

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--disable-ftok" unless build.include? 'with-ftok'
    if build.include? 'with-nls'
      gettext = Formula.factory('gettext')
      args << "--with-libintl-prefix=#{gettext.include}"
    else
      args << "--disable-nls"
    end

    system "./configure", *args
    system "make install"
  end
end
