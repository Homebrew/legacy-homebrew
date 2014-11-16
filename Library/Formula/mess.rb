require 'formula'

class Mess < Formula
  homepage "http://www.mess.org/"
  url "https://github.com/mamedev/mame/archive/mame0155.tar.gz"
  sha1 "0e56d53dd6dd916b3c29387112a7042befc501bd"
  version "0.155"

  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha1 "e5a44194f5e7498ef816530ec8196c1f96448f96" => :yosemite
    sha1 "6003ef6faaced6b86a8f63ab7a2ec33885c2fa75" => :mavericks
    sha1 "51c9c19ba6dfc316986406018da7a4f86c46dd1d" => :mountain_lion
  end

  depends_on 'sdl'

  def install
    ENV['MACOSX_USE_LIBSDL'] = '1'
    ENV['PTR64'] = (MacOS.prefer_64_bit? ? '1' : '0')

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}",
                   "TARGET=mess", "SUBTARGET=mess"

    if MacOS.prefer_64_bit?
      bin.install 'mess64' => 'mess'
    else
      bin.install 'mess'
    end
  end
end
