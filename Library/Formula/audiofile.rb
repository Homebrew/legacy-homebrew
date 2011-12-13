require 'formula'

class Audiofile < Formula
  url 'https://github.com/downloads/mpruett/audiofile/audiofile-0.3.2.tar.gz'
  sha1 'fb55a3c9153475daa8932d3626797e033d149c1d'
  homepage 'http://www.68k.org/~michael/audiofile/'

  depends_on 'lcov' if ARGV.include? '--with-lcov'

# Builds with all 3 compilers. Cheers Clang!

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
    hear = '/usr/bin/qlmanage'
    conv = "#{HOMEBREW_PREFIX}/bin/sfconvert"
    info = "#{HOMEBREW_PREFIX}/bin/sfinfo"

    puts ''
    if File.exist?("#{conv}") and File.exist?("#{inn}") and
       File.exist?("#{hear}") and File.exist?("#{info}")
      mktemp do
        system "#{conv} #{inn} #{out} format wave"
        system "#{info} --short --reporterror #{out}"
        system "#{hear} -p #{out}" if ARGV.verbose?
        puts ''
        oh1 <<-EOS.undent
          Cheers mate. You converted a system sound from the Audio
          Interchange File Format \"aiff\" to the MS RIFF Wave format.

        EOS
      end
    else
      opoo <<-EOS.undent
        The test program couldn't locate one of these files that normally exist:
           #{inn}
           #{conv}
           #{info}
           #{hear}
        We are sorry for the mistake.  Another test you can run on this software
        will occur during install if you add --with-check like this:

      EOS
      oh1 '    brew rm audiofile'
      oh1 '    brew -v install audiofile --with-check'
      puts ''
    end  # if-else
  end  # def test
end
