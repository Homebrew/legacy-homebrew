require "formula"

class Twister < Formula
  homepage "http://twister.net.co"
  url "https://github.com/miguelfreitas/twister-core/archive/v0.9.28.tar.gz"
  sha1 "53b03636ae4d7539002fe9c3cf2dd58e9657ac1e"

  head do
    url "https://github.com/miguelfreitas/twister-core.git"
  end

  depends_on "boost" => :build
  depends_on "miniupnpc" => :build
  depends_on "openssl" => :build
  depends_on "berkeley-db4" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  option "without-webui", "Build without web ui"

  def install
    if build.head?
      ln_s cached_download/".git", ".git"
    end

    system "./autotool.sh"

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-openssl=#{Formula["openssl"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"

    if build.with? "webui"
      html_dir = "#{ENV['HOME']}/Library/Application\ Support/Twister/html"

      if File.exists? html_dir
        File.rename html_dir, "#{ENV['HOME']}/Library/Application\ Support/Twister/html.bak-#{Time.now.strftime '%Y%m%d%H%M%S'}"
      end

      mkdir_p html_dir
      system "git clone https://github.com/miguelfreitas/twister-html.git ${HOME}/Library/Application\\ Support/Twister/html"
    end
  end

  test do
    data_dir = "/tmp/twister-#{Time.now.strftime '%Y%m%d%H%M%S'}"
    Dir.mkdir(data_dir) unless File.exists? data_dir
    system "#{bin}/twisterd -daemon -datadir=#{data_dir} -rpcuser=user -rpcpassword=password -rpcallowip=127.0.0.1"
    rm_r data_dir
  end
end
