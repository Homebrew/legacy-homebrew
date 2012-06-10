require 'formula'

class Audiofile < Formula
  homepage 'http://www.68k.org/~michael/audiofile/'
  url 'https://github.com/downloads/mpruett/audiofile/audiofile-0.3.4.tar.gz'
  sha1 'e6f664b0d551df35ce0c10e38e5617bcd4605335'

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
        One of the following files could not be located, and so
        the test was not executed:
           #{inn}
           #{conv_bin}
           #{info_bin}
           #{hear_bin}

        Audiofile can also be tested at build-time:
          brew install -v audiofile --with-check
      EOS
      return
    end

    mktemp do
      system conv_bin, inn, out, 'format', 'wave'
      system info_bin, '--short', '--reporterror', out
      system hear_bin, '-p', out if ARGV.verbose?
    end
  end
end
