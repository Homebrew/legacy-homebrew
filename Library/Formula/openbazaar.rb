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
    system "./pow.sh "+version
  end

end
