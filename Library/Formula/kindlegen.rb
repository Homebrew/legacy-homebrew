require 'formula'

class Kindlegen <Formula
  url 'http://s3.amazonaws.com/kindlegen/KindleGen_Mac_i386_v1.1.zip'
  homepage 'http://www.amazon.com/gp/feature.html?docId=1000234621'
  md5 '7a897829c50585523fe22f5bc1a998bc'
  version '1.1'

  def install
    mkdir bin
    
    prefix.install Dir['*']
    (bin/'kindlegen').make_link(prefix/'kindlegen')
  end

  def caveats; <<-EOS
We agreed to the KindleGen License Agreement for you by downloading KindleGen.
If this is unacceptable you should uninstall.

License information at:
http://www.amazon.com/gp/feature.html?docId=1000460351

For samples, please check:
  #{prefix}/Sample and #{prefix}/MultimediaSample
EOS
  end
end
