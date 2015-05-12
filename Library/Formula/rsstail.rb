class Rsstail < Formula
  homepage "http://www.vanheusden.com/rsstail/"
  url "http://www.vanheusden.com/rsstail/rsstail-1.8.tgz"
  sha256 "19284f3eca4bfa649f53848e19e6ee134bce17ccf2a22919cc8c600684877801"

  depends_on "libmrss"

  head "https://github.com/flok99/rsstail.git"

  def install
    if build.head?
      # Upstream bug: https://github.com/flok99/rsstail/pull/10
      ENV.append "LDFLAGS", "-liconv -lmrss"
      system "make", "-e"
    else
      system "make"
    end
    man1.install "rsstail.1"
    bin.install "rsstail"
  end

  test do
    actual = shell_output(
      "#{bin}/rsstail -1u http://feed.nashownotes.com/rss.xml"
    )
    assert_match /^Title: NA-\d\d\d-\d\d\d\d-\d\d-\d\d$/, actual
  end
end
