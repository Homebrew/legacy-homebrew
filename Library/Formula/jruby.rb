require "formula"

class Jruby < Formula
  homepage "http://www.jruby.org"
  url "http://jruby.org.s3.amazonaws.com/downloads/1.7.12/jruby-bin-1.7.12.tar.gz"
  sha256 "2c15858dbc06d6346a30704fb6dcc779f2e67053566c9c21973f96e309eac609"

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
