require 'formula'

class Jruby < Formula
  homepage 'http://www.jruby.org'
  url 'http://jruby.org.s3.amazonaws.com/downloads/1.7.8/jruby-bin-1.7.8.tar.gz'
  sha1 '6008ad7776db4b2d9acb8470b956b010180056e9'

  def install
    # Remove Windows files
    rm Dir['bin/*.{bat,dll,exe}']

    # Prefix a 'j' on some commands
    cd 'bin' do
      Dir['*'].each do |file|
        mv file, "j#{file}" unless file.match /^[j]/
      end
    end

    # Only keep the OS X native libraries
    cd 'lib/jni' do
      Dir['*'].each do |file|
        rm_rf file unless file.downcase == 'darwin'
      end
    end

    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def test
    system "#{bin}/jruby", "-e", "puts 'hello'"
  end
end
