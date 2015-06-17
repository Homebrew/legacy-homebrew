class Web100clt < Formula
  desc "Command-line version of NDT diagnostic client"
  homepage "http://software.internet2.edu/ndt/"
  url "http://software.internet2.edu/sources/ndt/ndt-3.7.0.2.tar.gz"
  sha256 "bd298eb333d4c13f191ce3e9386162dd0de07cddde8fe39e9a74fde4e072cdd9"

  bottle do
    sha256 "f768169a75bf0fc13d585a0beb78703f8519a4637244b9f70c85d94a573606a2" => :yosemite
    sha256 "63812ac3ca29ef2a156b94b42017f3aca605b59c86e9936ea9feaa86b6f6f1ac" => :mavericks
    sha256 "a2aff7d133ecc03d7230fcca40a45ce2288f5feb0fdf34f24f093a9b7af0fbd1" => :mountain_lion
  end

  depends_on "i2util"
  depends_on "jansson"
  depends_on "openssl"

  # fixes issue with new default secure strlcpy/strlcat functions in 10.9
  # https://code.google.com/p/ndt/issues/detail?id=106
  if MacOS.version >= :mavericks
    patch do
      url "https://gist.githubusercontent.com/igable/8077668/raw/4475e6e653f080be111fa0a3fd649af42fa14c3d/ndt-3.6.5.2-osx-10.9.patch"
      sha256 "86d2399e3d139c02108ce2afb45193d8c1f5782996714743ec673c7921095e8e"
    end
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # we only want to build the web100clt client so we need
    # to change to the src directory before installing.
    system "make", "-C", "src", "install"
    man1.install "doc/web100clt.man" => "web100clt.1"
  end

  test do
    system "#{bin}/web100clt", "-v"
  end
end
