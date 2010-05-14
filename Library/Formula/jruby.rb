require 'formula'

class Jruby < Formula
  url 'http://jruby.org.s3.amazonaws.com/downloads/1.5.0/jruby-bin-1.5.0.tar.gz'
  homepage 'http://www.jruby.org'
  md5 'fd5c0fa9e42cf499807711a8d98d5402'

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
