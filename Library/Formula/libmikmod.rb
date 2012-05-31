require 'formula'

class Libmikmod < Formula
  homepage 'http://mikmod.shlomifish.org'
  url 'http://mikmod.shlomifish.org/files/libmikmod-3.2.0b4.tar.gz'
  sha256 'da0c4fcfc5ca15c653baeb62b8cf91b35cfa11c1081a1aacc1e443a7d35db870'

  def options
    [[ '--with-debug', 'Enable debugging symbols']]
  end

  def install
    ENV.x11
    if ARGV.include? '--with-debug' then
      (ENV.compiler == :clang) ? ENV.Og : ENV.O2
    end

    # OSX has CoreAudio, but ALSA is not for this OS nor is SAM9407 nor ULTRA.
    args = %W[
      --prefix=#{prefix}
      --disable-alsa
      --disable-sam9407
      --disable-ultra
    ]
    args << '--with-debug' if ARGV.include? '--with-debug'
    mkdir 'macbuild' do
      system "../configure", *args
      system "make install"
    end
  end
end
