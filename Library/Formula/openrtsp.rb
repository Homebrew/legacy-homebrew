require 'formula'

class Openrtsp < Formula
  homepage 'http://www.live555.com/openRTSP'
  url 'http://www.live555.com/liveMedia/public/live.2014.10.21.tar.gz'
  sha1 'e493e0d6f7f2bf4be8e88393bb3ba583136bb271'

  bottle do
    cellar :any
    sha1 "21d6d05d03ecc8b563138bd35160d0aa90dcf29d" => :mavericks
    sha1 "2bd52bbadecc80025ed6c51e48aac06d0ce85aef" => :mountain_lion
    sha1 "714197f600b197b8e573a8c4983f8090fec30e0b" => :lion
  end

  option "32-bit"

  def install
    if build.build_32_bit? || !MacOS.prefer_64_bit?
      ENV.m32
      system "./genMakefiles macosx-32bit"
    else
      system "./genMakefiles macosx"
    end

    system "make", "PREFIX=#{prefix}", "install"
  end
end
