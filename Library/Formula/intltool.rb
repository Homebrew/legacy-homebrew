class Intltool < Formula
  homepage "https://wiki.freedesktop.org/www/Software/intltool"
  url "https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz"
  sha256 "67c74d94196b153b774ab9f89b2fa6c6ba79352407037c8c14d5aeb334e959cd"

  bottle do
    sha1 "88c0a273f4bb8c9df2e9250f7272117d55868b06" => :yosemite
    sha1 "36c951e99ec642add05e84acef83cf8c2bdb4b91" => :mavericks
    sha1 "edcf10d843211ca24dec1888281f3dfec76fa33b" => :mountain_lion
    sha1 "b2736b5eb60c9d346ef6f041f3fd66b220daca29" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"intltool-extract", "--help"
  end
end
