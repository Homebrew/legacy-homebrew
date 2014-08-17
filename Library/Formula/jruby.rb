require "formula"

class Jruby < Formula
  homepage "http://www.jruby.org"
  url "http://jruby.org.s3.amazonaws.com/downloads/1.7.13/jruby-bin-1.7.13.tar.gz"
  sha1 "8d26690be96e41950b643a5207936acac6392db0"

  def install
    # Remove Windows files
    rm Dir["bin/*.{bat,dll,exe}"]

    cd "bin" do
      # Prefix a 'j' on some commands to avoid clashing with other rubies
      %w{ast rake rdoc ri testrb}.each { |f| mv f, "j#{f}" }
      # Delete some unnecessary commands
      rm "gem" # gem is a wrapper script for jgem
      rm "irb" # irb is an identical copy of jirb
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
