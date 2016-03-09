class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "http://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://github.com/kazu-yamamoto/pgpdump/archive/v0.29.tar.gz"
  sha256 "b2b3ffe998eda901f4f888a62354730fb53840e68493cfff76962524c43e1d11"

  head "https://github.com/kazu-yamamoto/pgpdump.git"

  bottle do
    cellar :any
    sha256 "6498e4961fca95045a658fd53f8259e5ef4f1fa29cbf6e98c400ba7936fe423b" => :yosemite
    sha256 "776f42e2b4f27dfdfb1ef2700428bd32b4ad12cb2408537a32b3b488aea6f273" => :mavericks
    sha256 "8a4a87acaa4bd684365fdf9cef4cf58fcef591ba5230c5ff7f02db4ca3738d53" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"sig.pgp").write <<-EOS.undent
      -----BEGIN PGP MESSAGE-----
      Version: GnuPG v1.2.6 (NetBSD)
      Comment: For info see https://www.gnupg.org

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
