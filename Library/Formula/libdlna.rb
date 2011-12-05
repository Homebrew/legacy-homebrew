require 'formula'

class Libdlna < Formula
  url 'http://libdlna.geexbox.org/releases/libdlna-0.2.3.tar.bz2'
  homepage 'http://libdlna.geexbox.org/'
  md5 '2c974f95b711e5fd07f78fc4ebfcca66'

  depends_on 'ffmpeg'

  # Patches exist in the gentoo repository, but since the project isn't under active
  # development they may never get pulled officially.
  # fixes ffmpeg locations & missing symbols for newer versions of libavformat
  def patches
    [
      "https://gist.github.com/raw/356431/fbddfeee80d9224f6c67886b119fbd813f3c0ffa/libdlna.patch",
      "https://gist.github.com/raw/1434147/293ec631536bc34a6e2dd49bb0f30c86f02b1107/libdlna023_fix_symbols.patch"
    ]
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make install"
  end
end
