class Twister < Formula
  homepage "http://twister.net.co"
  url "https://github.com/miguelfreitas/twister-core/archive/v0.9.28.tar.gz"
  sha1 "53b03636ae4d7539002fe9c3cf2dd58e9657ac1e"

  head do
    url "https://github.com/miguelfreitas/twister-core.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db4"
  depends_on "boost"
  depends_on "libtool" => :build
  depends_on "miniupnpc" => :build
  depends_on "openssl"

  def install
    ENV["GIT_DIR"] = cached_download/".git" if build.head?

    system "./autotool.sh"

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-openssl=#{Formula["openssl"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent

    To use Web UI, you need to clone twister-webui project to your Library directory:

      git clone https://github.com/miguelfreitas/twister-html.git ${HOME}/Library/Application\\ Support/Twister/html

    EOS
  end

  test do
    # Add "; echo" because twisterd --help will return 1 as exit code.
    # I'll contact the author of Twister to fix it.
    system "#{bin}/twisterd --help; echo"
    system "which", "twisterd"
  end
end
