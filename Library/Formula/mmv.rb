require 'formula'

class Mmv <Formula
  url "http://ftp.de.debian.org/debian/pool/main/m/mmv/mmv_1.01b.orig.tar.gz"
  md5 '1b2135ab2f17bdfa9e08debbb3c46ad8'
  homepage 'http://packages.debian.org/unstable/utils/mmv'

  def patches
    "http://ftp.de.debian.org/debian/pool/main/m/mmv/mmv_1.01b-15.diff.gz"
  end

  def install
    system "make"

    bin.install 'mmv'
    man1.install 'mmv.1'

    %w[mcp mad mln].each do |mxx|
      FileUtils.ln bin+'mmv', bin+mxx
      FileUtils.ln man1+'mmv.1', man1+"#{mxx}.1"
    end
  end
end
