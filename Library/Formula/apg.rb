require 'formula'

class Apg <Formula
  url 'http://www.adel.nursat.kz/apg/download/apg-2.2.3.tar.gz'
  homepage 'http://www.adel.nursat.kz/apg/'
  md5 '3b3fc4f11e90635519fe627c1137c9ac'

  def install
    inreplace "Makefile" do |s|
      s.remove_make_var! ["CC", "FLAGS", "LIBS", "LIBM"]
    end

    system "make standalone"

    # Install manually
    bin.install ["apg", "apgbfm"]
    man1.install ["doc/man/apg.1", "doc/man/apgbfm.1"]
  end
end
