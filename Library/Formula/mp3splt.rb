require 'formula'

class Mp3splt < Formula
  homepage 'http://mp3splt.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/mp3splt/mp3splt/2.5.1/mp3splt-2.5.1.tar.gz'
  sha1 '75551f12f349312d2e8fcc58bbadab134e9e3a99'

  depends_on 'libmp3splt'

  def install
    # Use of getline(); see https://sourceforge.net/p/mp3splt/bugs/149/
    if MacOS.version <= :snow_leopard
      inreplace 'src/freedb.c', /getline\(&(.+, )&(.+, .+\) == )-1/, 'fgets(\1\2NULL'
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
