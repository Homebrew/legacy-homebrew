require 'formula'

class Tintin < Formula
  homepage 'http://tintin.sf.net'
  url 'http://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/2.00.8/tintin-2.00.8.tar.gz'
  sha256 'e364a7fa7ed35a2d166a081cce4682d5fe2481ee9ce72c6a409903d097e1ae45'

  depends_on 'pcre'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    cd 'src' do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end
end
