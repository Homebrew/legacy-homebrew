require 'formula'

class Libmikmod < Formula
  homepage 'http://mikmod.shlomifish.org'
  url 'https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.6/libmikmod-3.3.6.tar.gz'
  sha256 '3f363e03f7b1db75b9b6602841bbd440ed275a548e53545f980df8155de4d330'

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

  test do
    system "#{bin}/libmikmod-config", "--version"
  end
end
