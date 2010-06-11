require 'formula'

class Jruby < Formula
  url 'http://jruby.org.s3.amazonaws.com/downloads/1.5.1/jruby-bin-1.5.1.tar.gz'
  homepage 'http://www.jruby.org'
  md5 '74251383e08e8c339cacc35a7900d3af'

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
        rm_rf file unless file == 'darwin'
      end
    end

    prefix.install Dir['*']
  end

  def test
    system "jruby -e ''"
  end
end
