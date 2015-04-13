class LibgpgError < Formula
  homepage "https://www.gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.19.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.19.tar.bz2"
  sha256 "53120e1333d5c5d28d87ff2854e9e98719c8e214152f17ad5291704d25c4978b"

  bottle do
    cellar :any
    sha1 "ea42085dd9d363cfad2facb61777018255168cb0" => :yosemite
    sha1 "d3f1915a8a549edadbf40f6bcedd83b4559d8286" => :mavericks
    sha1 "57d378b5a7a2d1617e908b7ac81408ea918214b3" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
