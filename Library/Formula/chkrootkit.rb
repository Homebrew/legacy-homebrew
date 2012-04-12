require 'formula'

class Chkrootkit < Formula
  homepage 'http://www.chkrootkit.org/'
  url 'ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit-0.49.tar.gz'
  md5 '304d840d52840689e0ab0af56d6d3a18'

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
