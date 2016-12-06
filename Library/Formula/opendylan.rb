require 'formula'

class LionOrNewer < Requirement
  def satisfied?
    MacOS.version >= :lion
  end
  def fatal?
    true
  end
  def message
    "OpenDylan requires Mac OS X 10.7 (Lion) or newer."
  end
end

class Opendylan < Formula
  homepage 'http://opendylan.org/'
  url 'http://opendylan.org/downloads/opendylan/2012.1/opendylan-2012.1-x86-darwin.tar.bz2'
  sha1 '5f2e471e18a2e5ee7c2156593427a63c1d4415b2'

  depends_on LionOrNewer

  def install
    prefix.install Dir['*']
  end
end
