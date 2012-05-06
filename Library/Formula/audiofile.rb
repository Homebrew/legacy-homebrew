require 'formula'

class Audiofile < Formula
  url 'https://github.com/downloads/mpruett/audiofile/audiofile-0.3.2.tar.gz'
  sha1 'fb55a3c9153475daa8932d3626797e033d149c1d'
  homepage 'http://www.68k.org/~michael/audiofile/'

  depends_on 'lcov' if ARGV.include? '--with-lcov'

  def options
    [
      ['--with-lcov', 'Enable Code Coverage support using lcov.'],
      ['--with-check', 'Run the test suite during install ~30sec']
    ]
  end

  def install
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]
    args << '--enable-coverage' if ARGV.include? '--with-lcov'
    system "./configure", *args
    system "make"
    system "make check" if ARGV.include? '--with-check'
    system "make install"
  end

  def test
    inn  = '/System/Library/Sounds/Glass.aiff'
    out  = 'Glass.wav'
    hear_bin = '/usr/bin/qlmanage'
    conv_bin = "#{bin}/sfconvert"
    info_bin = "#{bin}/sfinfo"

    unless File.exist?(conv_bin) and File.exist?(inn) and
          File.exist?(hear_bin) and File.exist?(info_bin)
      opoo <<-EOS.undent
        The test program couldn't locate one of these files that normally exist:
           #{inn}
           #{conv_bin}
           #{info_bin}
           #{hear_bin}
        We are sorry for the mistake.  Another test you can run on this software
        will occur during install if you add --with-check like this:

      EOS
      oh1 '    brew rm audiofile'
      oh1 '    brew -v install audiofile --with-check'
      return
    end

    mktemp do
      system "#{conv_bin} #{inn} #{out} format wave"
      system "#{info_bin} --short --reporterror #{out}"
      system "#{hear_bin} -p #{out}" if ARGV.verbose?
      puts
      oh1 <<-EOS.undent
        Cheers mate. You converted a system sound from the Audio
        Interchange File Format \"aiff\" to the MS RIFF Wave format.
      EOS
    end
  end
end
