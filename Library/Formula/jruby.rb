require 'formula'

class Jruby < Formula
  url 'http://jruby.org.s3.amazonaws.com/downloads/1.6.5.1/jruby-bin-1.6.5.1.tar.gz'
  homepage 'http://www.jruby.org'
  md5 '246a7aa2b7d7e6e9e8a0c2e282cbcfd0'

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

  def test
    system "#{bin}/jruby -e 'puts \"hello\"'"
  end
end
