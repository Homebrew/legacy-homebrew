require 'formula'

class Aunit < Formula
  homepage 'http://libre.adacore.com/tools/aunit/'
  url 'http://mirrors.cdn.adacore.com/art/d1fa4a0eb6665edb5b330c50e82041e4923b208c'
  sha1 '4f367f7b65a20f46fd0543d89d1608253a27dda7'
  version '2012'

  depends_on 'gnat'

  def install
    system "make install INSTALL=#{prefix}"
  end

  def test
    mktemp do
      (Pathname.pwd + 'test.adb').write <<-ADA.undent
        with AUnit;
        
        procedure Test is
        begin
           null;
        end Test;
      ADA
      system "gnat compile -aI#{prefix}/include/aunit/framework/ test.adb"
    end
  end
end
