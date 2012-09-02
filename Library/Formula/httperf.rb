require 'formula'

class Httperf < Formula
  url 'http://httperf.googlecode.com/files/httperf-0.9.0.tar.gz'
  homepage 'http://code.google.com/p/httperf/'
  sha1 '2aa885c0c143d809c0e50a6eca5063090bddee35'

  def options
    [['--enable-debug', 'build with support for the --debug=N option']]
  end

  def install
    debug = ARGV.include?('--enable-debug') ? '--enable-debug' : '--disable-debug'

    system "./configure", "--prefix=#{prefix}", debug, "--disable-dependency-tracking"
    system "make install"
  end
end
