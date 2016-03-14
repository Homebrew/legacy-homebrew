class Jo < Formula
  desc "JSON output from a shell"
  homepage "https://github.com/jpmens/jo"
  url "https://github.com/jpmens/jo/releases/download/v1.0/jo-1.0.tar.gz"
  sha256 "d66ec97258d1afad15643fb2d5b5e807153a732ba45c2417adc66669acbde52e"

  bottle do
    cellar :any_skip_relocation
    sha256 "c94c62f3918266cbd688da0b54274226f0fc5d31b311b6be47f523d184f3e503" => :el_capitan
    sha256 "c46c74107062d4b419255e5a3bc44caea10cbc2ee290e7fdfbaa1dd254b18e4b" => :yosemite
    sha256 "25e096147b71cdfe6f6230b6340c577335517fabbbf05027f41db4878629f726" => :mavericks
  end

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
