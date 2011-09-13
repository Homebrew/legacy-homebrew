require 'formula'

class Jbigkit < Formula
  url 'http://www.cl.cam.ac.uk/~mgk25/download/jbigkit-2.0.tar.gz'
  homepage 'http://www.cl.cam.ac.uk/~mgk25/jbigkit/'
  md5 '3dd87f605abb1a97a22dc79d8b3e8f6c'

  def options
    [
      ['--checkit', "Verify the library during install. Takes ~10s."]
    ]
  end

  def install
    # jbigkit includes libjbig, a C Library for creating JBIG1 images, and two CLI programs
    # called pbmtojbg and jbgtopbm that function a la netpbm. Jbigkit builds without 'configure'
    # using a very simple Makefile where you adjust CCFLAGS.  The makefile came set to CC = gcc.
    # The Makefile overrides all relevant compiler variables except the MAKEFLAGS.
    # This library only builds a static library for your native architecture.
    # There is no make install code.

    # Patch the Makefile with the standard brew flags.
    inreplace 'Makefile', "CCFLAGS = -O2 -W", "CCFLAGS = -O3 -march=core2 -msse4 -arch x86_64 -w -pipe"

    # Build the package
    system "make"

    # Run the self-tests if the user optioned for that.
    # Need ENV.j1 to stop part of the test not finding a file still being converted.
    if ARGV.include? '--checkit'
      ENV.j1
      system "make test"
    end

    # Start the install here by making a few paths if they do not exist.
    contrib = prefix + 'contrib'
    examples = prefix + 'examples'
    src = prefix + 'src'
    lib.mkpath
    man1.mkpath
    man5.mkpath
    contrib.mkpath
    examples.mkpath
    include.mkpath
    src.mkpath

    # Install the files to the correct directories
    contrib.install Dir['contrib/*']
    examples.install Dir['examples/*']
    Dir.chdir 'pbmtools' do
      bin.install %w(pbmtojbg jbgtopbm pbmtojbg85 jbgtopbm85)
      man1.install %w(pbmtojbg.1 jbgtopbm.1)
      man5.install %w(pbm.5 pgm.5)
    end
    Dir.chdir 'libjbig' do
      lib.install Dir['lib*.a']
      src.install Dir['j*.c', 'j*.txt']
      include.install Dir['j*.h']
    end
  end

  def test
    puts
    system "#{HOMEBREW_PREFIX}/bin/jbgtopbm #{prefix}/examples/ccitt7.jbg | pbmtojbg - /tmp/testoutput.jbg"
    system "/usr/bin/cmp #{prefix}/examples/ccitt7.jbg /tmp/testoutput.jbg"
    puts
    ohai "The test was successful converting between jbig and pbm and back."
  end
end
