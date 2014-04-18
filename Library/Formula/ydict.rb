require 'formula'

class Ydict < Formula
  homepage 'https://github.com/chenpc/ydict'
  url 'https://github.com/chenpc/ydict/archive/1.3.4.tar.gz'
  sha1 'e88030060d752dc5486cf0f156d3f6ec41d84a55'

  def ydict_wrapper; <<-EOS.undent
    #!/bin/sh
    LC_ALL=en_US.UTF-8 "#{bin}/ydict.py" "$@"
    EOS
  end

  def install
    bin.install 'ydict' => 'ydict.py'
    (bin/'ydict').write(ydict_wrapper)
  end
end
