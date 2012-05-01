require 'formula'

class Libmikmod < Formula
  homepage 'http://mikmod.shlomifish.org'
  url 'http://mikmod.shlomifish.org/files/libmikmod-3.2.0b3.tar.gz'
  sha256 '3e2e04caff8726d5ceca0d8a5a1a43528cc627f935e92291aded1d87603ade4f'

  def options
    [[ '--with-debug', 'Enable debugging symbols']]
  end

  def install
    ENV.x11
    if ARGV.include? '--with-debug' then
      (ENV.compiler == :clang) ? ENV.Og : ENV.O2
    end

    # The following four patches have been merged upstream by Shlomi.
    # Remove them at 3.2.0b4 or 3.2.0 stable.  The explanation for these is
    # recorded here:  https://gist.github.com/2355354
    inreplace 'playercode/virtch_common.c', '(handle<MAXSAMPLEHANDLES)',
                                            '(Samples && handle<MAXSAMPLEHANDLES)'

    inreplace 'playercode/mdriver.c', 'extern MikMod_callback_t vc_callback',
                                      'MikMod_callback_t vc_callback'
    inreplace 'playercode/virtch_common.c', 'MikMod_callback_t vc_callback',
                                            'extern MikMod_callback_t vc_callback'

    inreplace 'playercode/virtch2.c', 'vc_callback((char*)vc_tickbuf, portion)',
                                      'vc_callback((unsigned char*)vc_tickbuf, portion)'


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
