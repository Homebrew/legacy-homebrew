class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "http://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://github.com/kazu-yamamoto/pgpdump/archive/v0.29.tar.gz"
  sha256 "b2b3ffe998eda901f4f888a62354730fb53840e68493cfff76962524c43e1d11"

  head "https://github.com/kazu-yamamoto/pgpdump.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "a8780ac54e115fc857b596515a81252ae8812b65008d1a39d537c28d4a90c4d6" => :el_capitan
    sha256 "a89324c5488f5f697bfe37cac80ea1cb0bde0d59895a526db0c2ee1031ef29e4" => :yosemite
    sha256 "8563fa2ae51f0138d070489f8501d3141c549e7e3e88db39e97c3e08524286fa" => :mavericks
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
