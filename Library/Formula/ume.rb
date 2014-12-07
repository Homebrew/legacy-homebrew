require 'formula'

class Ume < Formula
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0156.tar.gz"
  sha1 "9cda662385c0b168ca564dab0fb1e839065f6a01"
  version "0.156"

  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha1 "9850cfef7179c418ce1104edcdcfc0682f7979b3" => :yosemite
    sha1 "2afbdf96a4c6f45b04ada32debfdb86ef08aa2d2" => :mavericks
    sha1 "4e4684c5682424c294bc76d3ff12d9cdf3cdca88" => :mountain_lion
  end

  depends_on 'sdl2'

  # Fix for Cocoa framework linking and sdl-config path
  # It's been upstreamed, so remove from the next release
  # https://github.com/mamedev/mame/pull/60
  patch do
    url "https://github.com/mbcoguno/mame/commit/5d8dc09b12ea7d5576ef92e3e14a1db3654ff810.diff"
    sha1 "76c0f11f225968a10c0f024c55607e9f09634825"
  end

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
