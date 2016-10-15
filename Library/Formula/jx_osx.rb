class JxOsx < Formula
  homepage "http://jxcore.com/"
  url "https://s3.amazonaws.com/nodejx/jx_osx64.zip"
  sha256 "6bb4d2f81fc06b87a706a0161d6f4ced3002b7349e7330b645f80e75a641064d"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end
