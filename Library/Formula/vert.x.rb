require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class VertX < Formula
  homepage 'http://vertx.io/'
  url 'https://github.com/downloads/purplefox/vert.x/vert.x-1.0.final.tar.gz'
  md5 'ecfaf3a8e2c749e75b6618980255308e'

  def install
    # Remove Windows files
    rm_f Dir["bin/*.bat"]
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    Notes for using vert.x
    
    JDK. Vert.x requires JDK 1.7.0 or later. You can use the official 
    Oracle distribution or the OpenJDK version. Make sure the JDK bin 
    directory is on your PATH.
    
    EOS
  end
end
