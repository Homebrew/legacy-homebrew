require "formula"

class Reop < Formula
  homepage "http://www.tedunangst.com/flak/post/reop"
  head "https://github.com/tedu/reop.git"
  url "https://github.com/tedu/reop/archive/1.0.0.tar.gz"
  sha256 "8c2bf9a0b66e9a43cbcf3291858a97ccdc62736a378cd98aa3d3fc47f5db3798"

  depends_on "libsodium"

  def install
    system "make", "-f", "Makefile.osx"
    bin.install "reop"
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
