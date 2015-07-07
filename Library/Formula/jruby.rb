class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "http://www.jruby.org"
  url "https://s3.amazonaws.com/jruby.org/downloads/1.7.20.1/jruby-bin-1.7.20.1.tar.gz"
  sha256 "70bbd607b44c355b2de275cf24f6e4f724b30ef0affdcc31bc755717ccb9045a"

  devel do
    url "https://s3.amazonaws.com/jruby.org/downloads/9.0.0.0.rc1/jruby-bin-9.0.0.0.rc1.tar.gz"
    sha256 "b5c2bf5d4b22eba8ca62fe120aad682b8420454c12a426791a06f8efe6b90641"
    version "9.0.0.0.rc1"
  end

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
