require 'formula'

class Jad < Formula
  homepage 'http://www.varaneckas.com/jad/'
  url 'http://www.varaneckas.com/jad/jad158g.mac.intel.zip'
  sha1 '25bf73676eec21d4cf02f110cb7a06d37cb52f16'
  version '1.5.8g'

  def install
    man1.install Dir['jad.1']
    libexec.install Dir['jad']
    bin.install_symlink Dir["#{libexec}/jad"]    
  end

end
