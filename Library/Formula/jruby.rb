require 'formula'

class Jruby < Formula
  homepage 'http://www.jruby.org'
  url 'http://jruby.org.s3.amazonaws.com/downloads/1.7.11/jruby-bin-1.7.11.tar.gz'
  sha1 '1bec9fa355603b11ac9a1caa2aec790b06de7e5f'

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
    rm_rf Dir["lib/jni/*"] - ["lib/jni/Darwin"]
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/jruby", "-e", "puts 'hello'"
  end
end
