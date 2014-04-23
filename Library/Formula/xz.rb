require 'formula'

# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/homebrew/pull/21419
class Xz < Formula
  homepage 'http://tukaani.org/xz/'
  url 'http://fossies.org/linux/misc/xz-5.0.5.tar.gz'
  mirror 'http://tukaani.org/xz/xz-5.0.5.tar.gz'
  sha256 '5dcffe6a3726d23d1711a65288de2e215b4960da5092248ce63c99d50093b93a'

  bottle do
    cellar :any
    revision 3
    sha1 "d42b938770762ca46351f73f247b4b092d91c2ae" => :mavericks
    sha1 "16eb170fe01074ed3f49eb14c37f0608f208f555" => :mountain_lion
    sha1 "3052beb5c60568455182ee28129ca47648fd0659" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.xz
    system bin/"xz", path
    assert !path.exist?

    # decompress: data.txt.xz -> data.txt
    system bin/"xz", "-d", "#{path}.xz"
    assert_equal original_contents, path.read
  end
end
