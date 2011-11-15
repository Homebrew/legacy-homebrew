require 'formula'

class Jbigkit < Formula
  url 'http://www.cl.cam.ac.uk/~mgk25/download/jbigkit-2.0.tar.gz'
  homepage 'http://www.cl.cam.ac.uk/~mgk25/jbigkit/'
  md5 '3dd87f605abb1a97a22dc79d8b3e8f6c'

  def options
    [
      ['--with-check', "Verify the library during install. Takes ~10s."]
    ]
  end

  def install
    # Set for a universal build and patch the Makefile.
    # There's no configure. It creates a static lib.
    ENV.universal_binary
    inreplace 'Makefile', "CCFLAGS = -O2 -W", "CCFLAGS = #{ENV.cflags}"
    system "make"

    # It needs j1 to make the tests happen in sequence.
    ENV.deparallelize
    system "make test" if ARGV.include? '--with-check'

    # Install the files using three common styles of syntax:
    prefix.install %w[contrib examples]
    Dir.chdir 'pbmtools' do
      bin.install %w(pbmtojbg jbgtopbm pbmtojbg85 jbgtopbm85)
      man1.install %w(pbmtojbg.1 jbgtopbm.1)
      man5.install %w(pbm.5 pgm.5)
    end
    Dir.chdir 'libjbig' do
      lib.install Dir['lib*.a']
      (prefix+'src').install Dir['j*.c', 'j*.txt']
      include.install Dir['j*.h']
    end
  end

  def test
    puts
    mktemp do
      system "#{HOMEBREW_PREFIX}/bin/jbgtopbm #{prefix}/examples/ccitt7.jbg | pbmtojbg - testoutput.jbg"
      system "/usr/bin/cmp #{prefix}/examples/ccitt7.jbg testoutput.jbg"
      ohai "The test was successful converting between jbig and pbm and back."
      puts
      system "/usr/bin/file #{HOMEBREW_PREFIX}/lib/libjbig.a #{HOMEBREW_PREFIX}/lib/libjbig85.a"
      puts
    end
  end
end
