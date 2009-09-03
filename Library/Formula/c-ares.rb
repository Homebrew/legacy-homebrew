require 'brewkit'

class CAres <Formula
  @url='http://c-ares.haxx.se/c-ares-1.6.0.tar.gz'
  @homepage='http://c-ares.haxx.se/'
  @md5='4503b0db3dd79d3c1f58d87722dbab46'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
