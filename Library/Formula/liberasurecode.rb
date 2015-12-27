class Liberasurecode < Formula
  desc "Erasure Code API library written in C with pluggable backends"
  homepage "https://bitbucket.org/tsg-/liberasurecode/"
  url "https://bitbucket.org/tsg-/liberasurecode/downloads/liberasurecode-1.1.0.tar.gz"
  sha256 "3f8aadab190b82a3c18fdfc2c36a908a39e478d68e91f5d89a59849e91449039"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jerasure"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    system "true"
  end
end
