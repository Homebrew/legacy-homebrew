class Reop < Formula
  desc "Encrypted keypair management"
  homepage "http://www.tedunangst.com/flak/post/reop"
  url "http://www.tedunangst.com/flak/files/reop-2.1.0.tgz"
  sha256 "e429c7ff47f130bd465eaa0c23a1783b476bc484d32793592b54a568b55e49af"

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
