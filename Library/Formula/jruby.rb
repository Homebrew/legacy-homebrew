require 'formula'

class Jruby < Formula
  url 'http://jruby.org.s3.amazonaws.com/downloads/1.6.3/jruby-bin-1.6.3.tar.gz'
  homepage 'http://www.jruby.org'
  md5 '694b80e4eea784cdc1eb39fb1e3132c9'

  def install
    # Remove Windows files
    rm Dir['bin/*.{bat,dll,exe}']

    # Prefix a 'j' on some commands
    Dir.chdir 'bin' do
      Dir['*'].each do |file|
        mv file, "j#{file}" unless file.match /^[j_]/
      end
    end

    # Only keep the OS X native libraries
    Dir.chdir 'lib/native' do
      Dir['*'].each do |file|
        rm_rf file unless file.downcase == 'darwin'
      end
    end

    (prefix+'jruby').install Dir['*']

    bin.mkpath
    Dir["#{prefix}/jruby/bin/*"].each do |f|
      ln_s f, bin+File.basename(f)
    end
  end

  def caveats; <<-EOS.undent
    Consider using RVM to manage Ruby environments:
      * RVM: http://rvm.beginrescueend.com/
    EOS
  end

  def test
    system "jruby -e 'puts \"hello\"'"
  end
end
