require 'formula'

class Ume < Formula
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0155.tar.gz"
  sha1 "0e56d53dd6dd916b3c29387112a7042befc501bd"
  version "0.155"

  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha1 "9850cfef7179c418ce1104edcdcfc0682f7979b3" => :yosemite
    sha1 "2afbdf96a4c6f45b04ada32debfdb86ef08aa2d2" => :mavericks
    sha1 "4e4684c5682424c294bc76d3ff12d9cdf3cdca88" => :mountain_lion
  end

  depends_on 'sdl'

  def install
    ENV['MACOSX_USE_LIBSDL'] = '1'
    ENV['PTR64'] = (MacOS.prefer_64_bit? ? '1' : '0')

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}", "TARGET=ume"

    if MacOS.prefer_64_bit?
      bin.install 'ume64' => 'ume'
    else
      bin.install 'ume'
    end
  end
end
