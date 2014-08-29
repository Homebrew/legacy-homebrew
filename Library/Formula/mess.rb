require 'formula'

class Mess < Formula
  homepage 'http://www.mess.org/'
  url 'svn://dspnet.fr/mame/trunk', :revision => '31397'
  version '0.154'

  head 'svn://dspnet.fr/mame/trunk'

  bottle do
    cellar :any
    sha1 "dc6ff1625f345f6f810636bdd98a5a22fd8524eb" => :mavericks
    sha1 "0546864fa385c152fb93d8ed541b4fd38b96d88b" => :mountain_lion
    sha1 "e08903763afabce924b4253b165e21ffd24d3942" => :lion
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
