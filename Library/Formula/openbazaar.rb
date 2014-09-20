require "formula"

class Openbazaar < Formula
  homepage "https://openbazaar.org/"
  url "https://github.com/bitstopco/openbazaar-mac.git"

  version "0.1.0"

  depends_on "gpg"
  depends_on "sqlite3"
  depends_on "python"
  depends_on "wget"
  depends_on "openssl"
  depends_on "zmq"

  def install

    print "Installation may take a few minutes, depending on your computer specs. So go grab a beer 🍺"
    print " "

    system "./pow.sh "+version

    print " "

  end

  def caveats; <<-EOS.undent
      OpenBazaar configuration finished.

      Type openbazaar --help yo get started.

    EOS
  end

end
