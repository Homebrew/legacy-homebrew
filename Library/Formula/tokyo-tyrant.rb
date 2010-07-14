require 'formula'

class TokyoTyrant <Formula
  url 'http://1978th.net/tokyotyrant/tokyotyrant-1.1.40.tar.gz'
  homepage 'http://1978th.net/tokyotyrant/'
  md5 'cc9b7f0c6764d37700ab43d29a5c6048'

  depends_on 'tokyo-cabinet'
  depends_on 'lua' unless ARGV.include? "--no-lua"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-lua" unless ARGV.include? "--no-lua"
    
    system "./configure", *args
    system "make"
    system "make install"
  end
end
