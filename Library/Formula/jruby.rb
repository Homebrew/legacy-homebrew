require 'formula'

class Jruby < Formula
  homepage 'http://www.jruby.org'
  url 'http://jruby.org.s3.amazonaws.com/downloads/1.7.9/jruby-bin-1.7.9.tar.gz'
  sha1 '80b02217f9b9fa40df4a7cfbad916ff1911db23d'

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
