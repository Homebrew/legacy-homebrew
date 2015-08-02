class Hue < Formula
  desc "Hue is a Web interface for analyzing data with Apache Hadoop."
  homepage "http://gethue.com/"
  url "https://github.com/cloudera/hue/archive/release-3.8.1.tar.gz"
  sha256 "582777f567b9f4a34e4ce58cfd5ed24aff15f3e02f193e7990329d8cb0161a8a"

  depends_on :java
  depends_on :mysql

  depends_on "gmp"
  depends_on "maven" => :build
  depends_on "openssl"

  # Patches have been merged upstream.  Should try building next release
  # (> 3.8.1) without them.

  # Syntax error in 'parquet-python' library:
  #   https://github.com/cloudera/hue/pull/206
  patch do
    url "https://patch-diff.githubusercontent.com/raw/cloudera/hue/pull/206.patch"
    sha256 "20870269b1c903f9430fa6a924bb6be2010e8106aab9dd53970c2f8754d09fcc"
  end

  # Fix to allow 'pyopenssl' == 0.13 to build w/ OpenSSL >= 1.0.2a:
  #   https://github.com/cloudera/hue/pull/207
  patch do
    url "https://patch-diff.githubusercontent.com/raw/cloudera/hue/pull/207.patch"
    sha256 "3ae46b9e0a899d87199b4ee0511b3988bb91958603db8c543ef91462217bb2a8"
  end

  def install
    ENV.append_to_cflags "-I#{MacOS.sdk_path}/usr/include/sasl" if MacOS.version >= :mavericks
    ENV.deparallelize

    system "make", "install", "PREFIX=#{libexec}", "SKIP_PYTHONDEV_CHECK=1"

    (libexec/"hue/desktop/conf").install "desktop/conf.dist/hue.ini"
    etc.install_symlink "#{libexec}/hue/desktop/conf/hue.ini"

    bin.install_symlink "#{libexec}/hue/build/env/bin/hue"
  end

  test do
    fork do
      system "#{bin}/hue", "runserver"
    end
    sleep(6)

    begin
      system "curl", "-s", "-S", "-f", "-L", "http://localhost:8000"
      assert_equal 0, $?.exitstatus
    ensure
      sleep(2)
      system "pkill", "-f", "hue"
    end
  end
end
