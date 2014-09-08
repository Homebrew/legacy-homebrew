require "formula"

class Intltool < Formula
  homepage "http://www.freedesktop.org/wiki/Software/intltool"
  url "http://launchpad.net/intltool/trunk/0.50.2/+download/intltool-0.50.2.tar.gz"
  sha1 "7fddbd8e1bf94adbf1bc947cbf3b8ddc2453f8ad"

  bottle do
    sha1 "36c951e99ec642add05e84acef83cf8c2bdb4b91" => :mavericks
    sha1 "edcf10d843211ca24dec1888281f3dfec76fa33b" => :mountain_lion
    sha1 "b2736b5eb60c9d346ef6f041f3fd66b220daca29" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
