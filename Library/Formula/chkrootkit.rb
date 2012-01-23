require 'formula'

class Chkrootkit < Formula
  url 'ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit.tar.gz'
  homepage 'http://www.chkrootkit.org/'
  md5 '304d840d52840689e0ab0af56d6d3a18'
  version '0.49'

  def install
    chmod 0644, 'Makefile' # Makefile is read-only

    inreplace 'Makefile' do |s|
      s.remove_make_var! 'STATIC'
    end

    system "make CC=#{ENV.cc} sense"

    sbin.install ['check_wtmpx', 'chkdirs', 'chklastlog', 'chkproc',
                  'chkrootkit', 'chkutmp', 'chkwtmp', 'ifpromisc',
                  'strings-static']
    doc.install ['README', 'README.chklastlog', 'README.chkwtmp']
  end

  def test
    # pipe stdout to cat since chkrootkit -V exits with status 1
    system "#{sbin}/chkrootkit -V | cat"
  end
end
