require 'formula'

class Tintin < Formula
  homepage 'http://tintin.sf.net'
  url 'http://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/2.00.9/tintin-2.00.9.tar.gz'
  sha256 'cafeee9b60de39d957def5782fb4f8cb29a05af69dc96d3e5807c2d3fb541275'

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
