class Pgpdump < Formula
  homepage "http://www.mew.org/~kazu/proj/pgpdump/en/"
  url "http://www.mew.org/~kazu/proj/pgpdump/pgpdump-0.29.tar.gz"
  sha256 "6215d9af806399fec73d81735cf20ce91033a7a89a82c4318c4d1659083ff663"

  head "https://github.com/kazu-yamamoto/pgpdump.git"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"sig.pgp").write <<-EOS.undent
      -----BEGIN PGP MESSAGE-----
      Version: GnuPG v1.2.6 (NetBSD)
      Comment: For info see http://www.gnupg.org

      owGbwMvMwCSYq3dE6sEMJU7GNYZJLGmZOanWn4xaQzIyixWAKFEhN7W4ODE9VaEk
      XyEpVaE4Mz0vNUUhqVIhwD1Aj6vDnpmVAaQeZogg060chvkFjPMr2CZNmPnwyebF
      fJP+td+b6biAYb779N1eL3gcHUyNsjliW1ekbZk6wRwA
      =+jUx
      -----END PGP MESSAGE-----
    EOS

    assert_match(/Key ID - 0x6D2EC41AE0982209/,
                 shell_output("#{bin}/pgpdump sig.pgp"))
  end
end
