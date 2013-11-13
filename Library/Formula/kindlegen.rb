require 'formula'

class Kindlegen < Formula
  homepage 'http://www.amazon.com/gp/feature.html?docId=1000234621'
  url 'http://s3.amazonaws.com/kindlegen/KindleGen_Mac_i386_v2_7.zip'
  sha1 '66d555930e83e07cea771463815203fdbb2ecc8d'

  def install
    bin.install 'kindlegen'
    system "chmod +x #{File.join(prefix, 'bin/kindlegen')}"
  end

  test do
    system 'kindlegen'
  end

 def caveats; <<-EOS
We agreed to the KindleGen License Agreement for you by downloading KindleGen.
If this is unacceptable you should uninstall.

License information at:
http://www.amazon.com/gp/feature.html?docId=1000234621
EOS
  end
end
