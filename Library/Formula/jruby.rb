require 'formula'

class Jruby < Formula
  url 'http://jruby.kenai.com/downloads/1.4.0/jruby-bin-1.4.0.tar.gz'
  homepage 'http://www.jruby.org'
  md5 'f37322c18e9134e91e064aebb4baa4c7'

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
