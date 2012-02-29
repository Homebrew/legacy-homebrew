require 'formula'

class Py2cairo < Formula
  url 'http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2'
  homepage 'http://cairographics.org/pycairo/'
  md5 '20337132c4ab06c1146ad384d55372c5'

  depends_on 'cairo'

  def install
    # Python extensions default to universal but cairo may not be universal
    ENV['ARCHFLAGS'] = "-arch x86_64" unless ARGV.build_universal?
    system "./waf", "configure", "--prefix=#{prefix}", "--nopyc", "--nopyo"
    system "./waf", "install"
  end
end
