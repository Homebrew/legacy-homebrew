require 'formula'

class Libmikmod < Formula
  homepage 'http://mikmod.shlomifish.org'
  url 'http://sourceforge.net/projects/mikmod/files/libmikmod/3.3.3/libmikmod-3.3.3.tar.gz'
  sha256 '79f02478c5abd8b2af73df4cc5f9d52625aa044327c01563168e270cf79b2437'

  option 'with-debug', 'Enable debugging symbols'

  def install
    if build.with? 'debug'
      ENV.compiler == :clang ? ENV.Og : ENV.O2
    end

    # OSX has CoreAudio, but ALSA is not for this OS nor is SAM9407 nor ULTRA.
    args = %W[
      --prefix=#{prefix}
      --disable-alsa
      --disable-sam9407
      --disable-ultra
    ]
    args << '--with-debug' if build.with? 'debug'
    mkdir 'macbuild' do
      system "../configure", *args
      system "make install"
    end
  end

  def test
    system "#{bin}/libmikmod-config", "--version"
  end
end
