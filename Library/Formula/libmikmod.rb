require 'formula'

class Libmikmod < Formula
  homepage 'http://mikmod.shlomifish.org'
  url 'http://sourceforge.net/projects/mikmod/files/libmikmod/3.3.5/libmikmod-3.3.5.tar.gz'
  sha256 'b714ee340a04e6867f60246f679e0f40063b92f99269b6b715c8bf19ad469fb6'

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
