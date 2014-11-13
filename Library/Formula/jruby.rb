require "formula"

class Jruby < Formula
  homepage "http://www.jruby.org"
  url "https://s3.amazonaws.com/jruby.org/downloads/1.7.16.1/jruby-bin-1.7.16.1.tar.gz"
  sha1 "536b92c05812f6148674af2ad8dce199f74cf865"

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
