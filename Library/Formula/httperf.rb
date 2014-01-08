require 'formula'

class Httperf < Formula
  homepage 'http://code.google.com/p/httperf/'
  url 'http://httperf.googlecode.com/files/httperf-0.9.0.tar.gz'
  sha1 '2aa885c0c143d809c0e50a6eca5063090bddee35'

  option 'enable-debug', 'Build with debugging support'

  def install
    debug = build.include?('enable-debug') ? '--enable-debug' : '--disable-debug'

    system "./configure", debug,
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
