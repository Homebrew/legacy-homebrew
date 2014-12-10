require 'formula'

class Mmv < Formula
  homepage 'http://packages.debian.org/unstable/utils/mmv'
  url "http://mirrors.kernel.org/debian/pool/main/m/mmv/mmv_1.01b.orig.tar.gz"
  mirror 'http://ftp.us.debian.org/debian/pool/main/m/mmv/mmv_1.01b.orig.tar.gz'
  sha1 '538a26b1d7e8b9bc286843e6aa2d8d959d8914bb'

  patch do
    url "http://ftp.us.debian.org/debian/pool/main/m/mmv/mmv_1.01b-15.diff.gz"
    sha1 "101f42c641472c7fc1f2c2f7ef391c032cdbe3c0"
  end

  def install
    system "make", "CC=#{ENV.cc}", "LDFLAGS="

    bin.install 'mmv'
    man1.install 'mmv.1'

    %w[mcp mad mln].each do |mxx|
      bin.install_symlink "mmv" => mxx
      man1.install_symlink "mmv.1" => "#{mxx}.1"
    end
  end
end
