require 'formula'

class TokyoTyrant < Formula
  homepage 'http://fallabs.com/tokyotyrant/'
  url 'http://fallabs.com/tokyotyrant/tokyotyrant-1.1.41.tar.gz'
  sha1 '060ac946a9ac902c1d244ffafd444f0e5840c0ce'

  option "no-lua", "Disable Lua support"

  depends_on 'tokyo-cabinet'
  depends_on 'lua' => :recommended unless build.include? "no-lua"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-lua" unless build.include? "no-lua"

    system "./configure", *args
    system "make"
    system "make install"
  end
end
