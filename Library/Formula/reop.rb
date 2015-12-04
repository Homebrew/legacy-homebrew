class Reop < Formula
  desc "Encrypted keypair management"
  homepage "http://www.tedunangst.com/flak/post/reop"
  url "http://www.tedunangst.com/flak/files/reop-2.1.0.tgz"
  sha256 "e429c7ff47f130bd465eaa0c23a1783b476bc484d32793592b54a568b55e49af"
  revision 1

  bottle do
    cellar :any
    sha256 "ab56f50d663731a70446daea85a616c84643fe263d3550546c19049fde21af0c" => :el_capitan
    sha256 "6f8ed983458773d51cf1a7fa0a36c655bcb4d1e4ad0eaff9734c32df4f6259b1" => :yosemite
    sha256 "1691a7dff3d0b17dc585d1aa1841e80ad0101ea0f0253fa8e53ee1d510acf076" => :mavericks
  end

  depends_on "libsodium"

  def install
    system "make", "-f", "GNUmakefile"
    bin.install "reop"
    man1.install "reop.1"
  end

  test do
    (testpath/"pubkey").write <<-EOS.undent
      -----BEGIN REOP PUBLIC KEY-----
      ident:root
      RWRDUxZNDeX4wcynGeCr9Bro6Ic7s1iqi1XHYacEaHoy+7jOP+ZE0yxR+2sfaph2MW15e8eUZvvI
      +lxZaqFZR6Kc4uVJnvirIK97IQ==
      -----END REOP PUBLIC KEY-----
    EOS

    (testpath/"msg").write <<-EOS.undent
      testing one two three four
    EOS

    (testpath/"sig").write <<-EOS.undent
      -----BEGIN REOP SIGNATURE-----
      ident:root
      RWQWTQ3l+MHMpx8RO/+BX/xxHn0PiSneiJ1Au2GurAmx4L942nZFBRDOVw2xLzvp/RggTVTZ46k+
      GLVjoS6fSuLneCfaoRlYHgk=
      -----END REOP SIGNATURE-----
    EOS

    system "#{bin}/reop", "-V", "-x", "sig", "-p", "pubkey", "-m", "msg"
  end
end
