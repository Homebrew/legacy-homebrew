require 'formula'

class Libmikmod < Formula
  homepage 'http://mikmod.shlomifish.org'
  url 'http://sourceforge.net/projects/mikmod/files/libmikmod/3.3.4/libmikmod-3.3.4.tar.gz'
  sha256 '2e8ca1d945ff7330741d085548a6d4e8b2f6a9d41edda773607905d8905683ae'

  option 'with-debug', 'Enable debugging symbols'

  def install
    ENV.O2 if build.with? 'debug'

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
