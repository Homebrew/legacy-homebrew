require 'formula'

class Micropolis < Formula
  url 'git://git.zerfleddert.de/micropolis', :tag => '6fa8547948f4f5c46552f5d61a999e1943e20391'
  head 'git://git.zerfleddert.de/micropolis'
  version '2010-12-18'
  homepage 'http://git.zerfleddert.de/cgi-bin/gitweb.cgi/micropolis'

  def skip_clean? path
    true
  end

  def install
    ENV.deparallelize
    ENV.no_optimization

    # correct prefix in Makefile
    inreplace 'Makefile' do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "DATADIR", "#{var}/share/micropolis"
    end

    # separate make and make install steps
    system "make"
    system "make install"
  end

  def test
    system "which micropolis"
  end
end