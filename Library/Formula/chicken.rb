require 'formula'

class Chicken < Formula
  homepage 'http://www.call-cc.org/'
  url 'http://code.call-cc.org/releases/4.8.0/chicken-4.8.0.5.tar.gz'
  sha1 'fb393e49433c183d6a97da9b1ca48cb09ed51d72'

  head 'git://code.call-cc.org/chicken-core'

  def install
    ENV.deparallelize
    # Chicken uses a non-standard var. for this
    args = ["PREFIX=#{prefix}", "PLATFORM=macosx", "C_COMPILER=#{ENV.cc}"]
    args << "ARCH=x86-64" if MacOS.prefer_64_bit?
    system "make", *args
    system "make", "install", *args
  end

  test do
    output = `'#{bin}/csi' -e '(print (* 5 5))'`
    assert_equal "25", output.strip
    assert $?.success?
  end
end
