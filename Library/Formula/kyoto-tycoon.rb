require 'formula'

class KyotoTycoon < Formula
  url 'http://fallabs.com/kyototycoon/pkg/kyototycoon-0.9.42.tar.gz'
  homepage 'http://fallabs.com/kyototycoon/'
  sha1 'c51ac6bff82bdda6f04e2951fbeb93331f575281'

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
