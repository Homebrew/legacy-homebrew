require 'formula'

class Py2cairo < Formula
  homepage 'http://cairographics.org/pycairo/'
  url 'http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2'
  md5 '20337132c4ab06c1146ad384d55372c5'

  depends_on 'cairo'
  depends_on :x11

  def options
    [['--universal', 'Build universal binaries']]
  end

  def install
    # Python extensions default to universal but cairo may not be universal
    unless ARGV.build_universal?
      ENV['ARCHFLAGS'] = if MacOS.prefer_64_bit?
        "-arch x86_64"
      else
        "-arch i386"
      end
    end

    system "./waf", "configure", "--prefix=#{prefix}", "--nopyc", "--nopyo"
    system "./waf", "install"
  end
end
