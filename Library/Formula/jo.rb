class Jo < Formula
  desc "JSON output from a shell"
  homepage "https://github.com/jpmens/jo"

  url "https://github.com/jpmens/jo/releases/download/v1.0/jo-1.0.tar.gz"
  sha256 "d66ec97258d1afad15643fb2d5b5e807153a732ba45c2417adc66669acbde52e"

  head do
    url "https://github.com/jpmens/jo.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal %({"success":true,"result":"pass"}\n), pipe_output("#{bin}/jo success=true result=pass")
  end
end
