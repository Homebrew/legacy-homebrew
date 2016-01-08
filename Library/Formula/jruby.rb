class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "http://www.jruby.org"
  url "https://s3.amazonaws.com/jruby.org/downloads/9.0.4.0/jruby-bin-9.0.4.0.tar.gz"
  sha256 "fcf828c4ad5b92430a349f1e873c067a15e0952d167d07368135c513fe0d18fb"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    # Remove Windows files
    rm Dir["bin/*.{bat,dll,exe}"]

    cd "bin" do
      # Prefix a 'j' on some commands to avoid clashing with other rubies
      %w[ast rake rdoc ri testrb].each { |f| mv f, "j#{f}" }
      # Delete some unnecessary commands
      rm "gem" # gem is a wrapper script for jgem
      rm "irb" # irb is an identical copy of jirb
    end

    # Only keep the OS X native libraries
    rm_rf Dir["lib/jni/*"] - ["lib/jni/Darwin"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/jruby", "-e", "puts 'hello'"
  end
end
