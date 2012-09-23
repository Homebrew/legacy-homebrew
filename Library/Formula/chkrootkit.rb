require 'formula'

class Chkrootkit < Formula
  homepage 'http://www.chkrootkit.org/'
  url 'http://ftp.de.debian.org/debian/pool/main/c/chkrootkit/chkrootkit_0.49.orig.tar.gz'
  sha1 'cec1a3c482b95b20d3a946b07fffb23290abc4a6'

  def install
    chmod 0644, 'Makefile' # Makefile is read-only

    inreplace 'Makefile' do |s|
      s.remove_make_var! 'STATIC'
    end

    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "sense", "all"

    sbin.install %w{check_wtmpx chkdirs chklastlog chkproc
                    chkrootkit chkutmp chkwtmp ifpromisc
                    strings-static}
    doc.install %w{README README.chklastlog README.chkwtmp}
  end

  def test
    # pipe stdout to cat since chkrootkit -V exits with status 1
    system "#{sbin}/chkrootkit -V | cat"
  end
end
