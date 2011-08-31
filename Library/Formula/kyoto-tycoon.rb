require 'formula'

class KyotoTycoon < Formula
  url 'http://fallabs.com/kyototycoon/pkg/kyototycoon-0.9.49.tar.gz'
  homepage 'http://fallabs.com/kyototycoon/'
  sha1 '50832133c6c645ffbb994b2d83a3e8bb7f5ae669'

  depends_on 'lua' unless ARGV.include? "--no-lua"
  depends_on 'kyoto-cabinet'

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
