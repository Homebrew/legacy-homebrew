require 'formula'

# Upstream project has requested we use a mirror as the main URL
# https://github.com/mxcl/homebrew/pull/21419
class Xz < Formula
  homepage 'http://tukaani.org/xz/'
  url 'http://fossies.org/linux/misc/xz-5.0.5.tar.gz'
  mirror 'http://tukaani.org/xz/xz-5.0.5.tar.gz'
  sha256 '5dcffe6a3726d23d1711a65288de2e215b4960da5092248ce63c99d50093b93a'

  bottle do
    sha1 '08b71836cce456f716a9415c1565eba5f172c735' => :mavericks
    sha1 '9cc36f16730d913cfa6644eeaff6e5091a8e9602' => :mountain_lion
    sha1 '4a181308ba15a63f7876d8b3852136288af78d28' => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
