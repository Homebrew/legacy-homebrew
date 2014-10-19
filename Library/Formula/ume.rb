require 'formula'

class Ume < Formula
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0155.tar.gz"
  sha1 "0e56d53dd6dd916b3c29387112a7042befc501bd"
  version "0.155"

  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha1 "9355c003f65ff30d16dbdd304a340bcb5fb81b61" => :mavericks
    sha1 "d88f548400574c40e2df081e50ec37c1381edd07" => :mountain_lion
    sha1 "4a8c91568ef915b0cad541e7b8db71c3545808ef" => :lion
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
