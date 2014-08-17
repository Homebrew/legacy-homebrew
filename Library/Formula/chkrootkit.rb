require 'formula'

class Chkrootkit < Formula
  homepage 'http://www.chkrootkit.org/'
  url 'http://ftp.de.debian.org/debian/pool/main/c/chkrootkit/chkrootkit_0.49.orig.tar.gz'
  sha1 'cec1a3c482b95b20d3a946b07fffb23290abc4a6'

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "STATIC=",
                   "sense", "all"

    bin.install %w{check_wtmpx chkdirs chklastlog chkproc
                    chkrootkit chkutmp chkwtmp ifpromisc
                    strings-static}
    doc.install %w{README README.chklastlog README.chkwtmp}
  end

  test do
    assert_equal "chkrootkit version #{version}",
                 shell_output("#{bin}/chkrootkit -V 2>&1", 1).strip
  end
end
