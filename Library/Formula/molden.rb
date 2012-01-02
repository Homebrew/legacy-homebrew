require 'formula'

class Molden < Formula
  url 'ftp://ftp.cmbi.ru.nl/pub/molgraph/molden/molden5.0.tar.gz'
  homepage 'http://www.cmbi.ru.nl/molden/'
  md5 'e3726bc7cfd796f70dba2d903faec7ea'

  def install
    inreplace 'Makefile' do |s|
        s.change_make_var! "CC", ENV.cc
        s.change_make_var! "FORTRAN", ENV.fortran
    end

    system "make"

    bin.install ["gmolden", "molden"]

  end

  def test
    system "molden -h"
  end
end
