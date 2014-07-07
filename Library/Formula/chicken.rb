require 'formula'

class Chicken < Formula
  homepage 'http://www.call-cc.org/'
  url 'http://code.call-cc.org/releases/4.9.0/chicken-4.9.0.1.tar.gz'
  sha1 'd6ec6eb51c6d69e006cc72939b34855013b8535a'

  head 'git://code.call-cc.org/chicken-core'

  bottle do
    sha1 "18413b340d0dc2486f132dbd3997911d00eb3706" => :mavericks
    sha1 "f29dfe8f310772927022f175d60cb30c7c761b2d" => :mountain_lion
    sha1 "86d71f277efc7b45ae4a1d1b0bcab326f8aafdb1" => :lion
  end

  def install
    ENV.deparallelize
    # Chicken uses a non-standard var. for this
    args = ["PREFIX=#{prefix}", "PLATFORM=macosx", "C_COMPILER=#{ENV.cc}"]
    args << "ARCH=x86-64" if MacOS.prefer_64_bit?
    # necessary to fix build on older XCodes due to different path
    if MacOS::Xcode.installed?
      args << "XCODE_DEVELOPER=#{MacOS::Xcode.prefix}"
      args << "XCODE_TOOL_PATH=#{MacOS.sdk_path}/usr/bin"
    end
    system "make", "install", *args
  end

  test do
    output = `'#{bin}/csi' -e '(print (* 5 5))'`
    assert_equal "25", output.strip
    assert $?.success?
  end
end
