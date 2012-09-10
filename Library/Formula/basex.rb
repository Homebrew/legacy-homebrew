require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Basex < Formula
  homepage 'http://basex.org'
  version '7.3'
  url 'http://files.basex.org/releases/7.3/BaseX73.zip'
  sha1 'f996b953c08a3a0bdce0985e0f939d4854216413'

  # depends_on 'cmake' => :build
  

  def install
    # ENV.j1  # if your formula's build system can't parallelize
    rm Dir['bin/*.bat']
    rm_rf "repo"
    rm_rf "data"
    rm_rf "etc"
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test BaseX`.
    system "#{bin}/basex", "'1 to 10'"
  end
end
