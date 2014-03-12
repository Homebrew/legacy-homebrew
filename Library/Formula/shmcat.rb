require 'formula'

class Shmcat < Formula
  homepage 'http://shmcat.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/shmcat/shmcat-1.6.tar.bz2'
  sha1 '13650adef363bf9c7c97602036cf6c3241f1a86d'

  option 'with-ftok', "Build the ftok utility"
  option 'with-nls', "Use Native Language Support"

  depends_on 'gettext' if build.with? "nls"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--disable-ftok" if build.without? "ftok"
    if build.with? "nls"
      gettext = Formula['gettext']
      args << "--with-libintl-prefix=#{gettext.include}"
    else
      args << "--disable-nls"
    end

    system "./configure", *args
    system "make install"
  end
end
