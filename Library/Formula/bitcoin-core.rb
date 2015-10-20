class BitcoinCore < Formula
  desc "Headless bitcoin client"
  homepage "https://github.com/bitcoin/bitcoin"

  head "https://github.com/bitcoin/bitcoin.git"

  stable do
    url "https://github.com/bitcoin/bitcoin/archive/v0.11.1.tar.gz"
    version "0.11.1"
    sha256 "6b238ab46bb10c7a83237dfd69b09c95f08043bbe0b478f9c256b9536186b8d2"
  end

  devel do
    url "https://github.com/bitcoin/bitcoin/archive/v0.11.1rc2.tar.gz"
    version "0.11.1rc2"
    sha256 "cfc9b09d95d891e2476c78a107f109f06bcbe6eb60aa208d0e9788c882ce7fa2"
  end

  option "without-gui", "Build without Qt5 GUI"
  option "without-wallet", "Build without wallet support"

  option "without-utils", "Build without bitcoin CLI utils"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "openssl"
  depends_on "miniupnpc"
  depends_on "berkeley-db4" if build.with? "wallet"

  if build.with? "gui"
    depends_on "qt5" => ["with-d-bus", "with-developer"]
    depends_on "protobuf"
    depends_on "qrencode"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-boost=#{Formula["boost"].prefix}
      --with-miniupnpc
    ]

    if build.with? "gui"
      args += %W[
        --with-gui=qt5
        --with-qtdbus
        --with-qrencode
        --with-protoc-bindir=#{Formula["protobuf"].bin}
      ]
    else
      args << "--with-gui=no"
    end

    # For build without CLI tools
    if build.without? "utils"
      args << "--without-utils"
    end

    if build.without? "wallet"
      args << "--disable-wallet"
    end

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"test_bitcoin", "-i"

    if build.with? "gui"
        system bin/"test_bitcoin-qt"
    end
  end

  def caveats; <<-EOS.undent
    You should create RPC configuration file by running this command:
    echo -e "rpcuser=bitcoinrpc\\nrpcpassword=$(xxd -l 16 -p /dev/urandom)" > "/Users/${USER}/Library/Application Support/Bitcoin/bitcoin.conf"
  EOS
  end
end
