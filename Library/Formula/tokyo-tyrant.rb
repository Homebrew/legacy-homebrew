require 'formula'

class TokyoTyrant <Formula
  url 'http://fallabs.com/tokyotyrant/tokyotyrant-1.1.41.tar.gz'
  homepage 'http://fallabs.com/tokyotyrant/'
  md5 'a47e58897bd1cbbac173d5a66cc32ae3'

  depends_on 'tokyo-cabinet'
  depends_on 'lua' unless ARGV.include? "--no-lua"

  def options
    [["--no-lua", "Disable Lua support (and don't force Lua install.)"]]
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-lua" unless ARGV.include? "--no-lua"

    system "./configure", *args
    system "make"
    system "make install"
  end
end
