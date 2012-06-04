require 'formula'

class KyotoTycoon < Formula
  homepage 'http://fallabs.com/kyototycoon/'
  url 'http://fallabs.com/kyototycoon/pkg/kyototycoon-0.9.56.tar.gz'
  sha1 'e5433833e681f8755ff6b9f7209029ec23914ce6'

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
