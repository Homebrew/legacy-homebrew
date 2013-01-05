require 'formula'

class Jruby < Formula
  homepage 'http://www.jruby.org'
  url 'http://jruby.org.s3.amazonaws.com/downloads/1.7.2/jruby-bin-1.7.2.tar.gz'
  sha1 'a51611bf23993f3b6bb5e781b97100ea99f4e702'

  env :std

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
    cd 'lib/native' do
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
