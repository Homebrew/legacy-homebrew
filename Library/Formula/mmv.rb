require 'formula'

class Mmv < Formula
  homepage 'http://packages.debian.org/unstable/utils/mmv'
  url "http://mirrors.kernel.org/debian/pool/main/m/mmv/mmv_1.01b.orig.tar.gz"
  mirror 'http://ftp.us.debian.org/debian/pool/main/m/mmv/mmv_1.01b.orig.tar.gz'
  sha1 '538a26b1d7e8b9bc286843e6aa2d8d959d8914bb'

  def patches
    "http://ftp.us.debian.org/debian/pool/main/m/mmv/mmv_1.01b-15.diff.gz"
  end

  def install
    system "make"

    bin.install 'mmv'
    man1.install 'mmv.1'

    %w[mcp mad mln].each do |mxx|
      ln bin+'mmv', bin+mxx
      ln man1+'mmv.1', man1+"#{mxx}.1"
    end
  end
end
