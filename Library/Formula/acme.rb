require 'formula'

class Acme < Formula
  homepage 'http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/'
  url 'http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/current/acme091src.tar.gz'
  version '0.91'
  sha1 '7104ea01a2ca2962294aaac4974e10c6486534a8'

  def install
    cd "src" do
      system "make", "install", "BINDIR=#{bin}"
    end
  end

  test do
    system bin/'acme', '-V'
  end
end
