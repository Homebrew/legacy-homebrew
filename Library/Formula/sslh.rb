class Sslh < Formula
  homepage "http://www.rutschle.net/tech/sslh.shtml"

  stable do
    url "http://www.rutschle.net/tech/sslh-v1.17.tar.gz"
    sha256 "4f3589ed36d8a21581268d53055240eee5e5adf02894a2ca7a6c9022f24b582a"

    # fixes `make install`, fixed in HEAD
    patch do
      url "https://github.com/yrutschle/sslh/commit/7c35ef8528d47b97894a6495275b57dc1ae3f8c7.diff"
      sha256 "a6f8e1c3f9776d7344ea839de1d8a40e9925101528bd3beee50a0c60c62872cf"
    end
  end

  head "https://github.com/yrutschle/sslh.git"

  depends_on "libconfig"

  def install
    ENV.j1
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system sbin/"sslh", "-V"
  end
end
