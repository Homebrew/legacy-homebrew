require 'formula'

class Libdlna <Formula
  url 'http://libdlna.geexbox.org/releases/libdlna-0.2.3.tar.bz2'
  homepage 'http://libdlna.geexbox.org/'
  md5 '2c974f95b711e5fd07f78fc4ebfcca66'

  depends_on 'ffmpeg'

  def patches
    # fixes ffmpeg locations
    "https://gist.github.com/raw/356431/fbddfeee80d9224f6c67886b119fbd813f3c0ffa/libdlna.patch"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make install"
  end
end
