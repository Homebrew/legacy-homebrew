class Pound < Formula
  homepage "http://www.apsis.ch/pound"
  url "http://www.apsis.ch/pound/Pound-2.7.tgz"
  sha256 "cdfbf5a7e8dc8fbbe0d6c1e83cd3bd3f2472160aac65684bb01ef661c626a8e4"

  depends_on "openssl"
  depends_on "pcre"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    # Manual install to get around group issues
    sbin.install "pound", "poundctl"
    man8.install "pound.8", "poundctl.8"
  end

  test do
    assert_match(/^Version #{version}$/m, `#{sbin}/pound -V`)
  end
end
