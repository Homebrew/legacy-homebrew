require 'formula'

class Libmikmod < Formula
  homepage 'http://mikmod.shlomifish.org'
  url 'http://mikmod.shlomifish.org/files/libmikmod-3.2.0.tar.gz'
  sha256 '734c8490bbf9b0c587920b92414dcfa3c2267838a0cdf698d5f1fb6bba8f661e'

  option 'with-debug', 'Enable debugging symbols'

  def install
    if build.include? 'with-debug'
      (ENV.compiler == :clang) ? ENV.Og : ENV.O2
    end

    # OSX has CoreAudio, but ALSA is not for this OS nor is SAM9407 nor ULTRA.
    args = %W[
      --prefix=#{prefix}
      --disable-alsa
      --disable-sam9407
      --disable-ultra
    ]
    args << '--with-debug' if build.include? 'with-debug'
    mkdir 'macbuild' do
      system "../configure", *args
      system "make install"
    end
  end

  def test
    system "#{bin}/libmikmod-config", "--version"
  end
end
