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
    system "make", "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}"

    # It needs j1 to make the tests happen in sequence.
    ENV.deparallelize
    system "make test" if ARGV.include? '--with-check'

    # Install the files using three common styles of syntax:
    prefix.install %w[contrib examples]
    cd 'pbmtools' do
      bin.install %w(pbmtojbg jbgtopbm pbmtojbg85 jbgtopbm85)
      man1.install %w(pbmtojbg.1 jbgtopbm.1)
      man5.install %w(pbm.5 pgm.5)
    end
    cd 'libjbig' do
      lib.install Dir['lib*.a']
      (prefix+'src').install Dir['j*.c', 'j*.txt']
      include.install Dir['j*.h']
    end
  end

  def test
    mktemp do
      system "#{bin}/jbgtopbm #{prefix}/examples/ccitt7.jbg | #{bin}/pbmtojbg - testoutput.jbg"
      system "/usr/bin/cmp #{prefix}/examples/ccitt7.jbg testoutput.jbg"
    end
  end
end
