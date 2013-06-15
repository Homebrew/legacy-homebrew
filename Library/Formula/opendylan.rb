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

  head 'https://github.com/dylan-lang/opendylan.git'

  if build.head?
    depends_on 'autoconf'
    depends_on 'automake'
    depends_on 'bdw-gc'
  end
  depends_on LionOrNewer.new

  def install

    ENV.j1

    if build.head?
      ohai "Compilation takes a long time; use `brew install -v opendylan` to see progress" unless ARGV.verbose?
      system "./autogen.sh"
      system "./configure", "--prefix=#{prefix}"
      system "make 3-stage-bootstrap"
      system "make install"
    else
      prefix.install Dir['*']
    end
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test opendylan`.
    system "false"
  end
end
