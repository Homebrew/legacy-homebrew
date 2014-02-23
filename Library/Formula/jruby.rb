require 'formula'

class Jruby < Formula
  homepage 'http://www.jruby.org'
  url 'http://jruby.org.s3.amazonaws.com/downloads/1.7.10/jruby-bin-1.7.10.tar.gz'
  sha1 '5ec267dd3ddaa6e27801692a7080204067662289'

  def install
    # Remove Windows files
    rm Dir['bin/*.{bat,dll,exe}']

    cd 'bin' do
      # Prefix a 'j' on some commands to avoid clashing with other ruby installations
      ['ast', 'rake', 'rdoc', 'ri', 'testrb'].each { |f| mv f, "j#{f}" }
      # Delete some unnecessary command
      #  gem is a wrapper script for jgem
      #  irb is an identical copy of jirb
      ['gem', 'irb'].each { |f| rm f }
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

  test do
    system "#{bin}/jruby", "-e", "puts 'hello'"
  end
end
