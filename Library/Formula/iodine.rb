require 'formula'

class Iodine < Formula
  homepage 'http://code.kryo.se/iodine/'
  url 'http://code.kryo.se/iodine/iodine-0.7.0.tar.gz'
  sha1 'f4c49305b6f46a547b160b3bd8c962942d701a63'

  bottle do
    cellar :any
    sha1 "01e0ab026e082803d4d1f04f90d6afe28b5baeb9" => :mavericks
    sha1 "39e539f323810586316599e296120398afd55431" => :mountain_lion
    sha1 "1afe02179eaa83f66382eaf296023c574e351f79" => :lion
  end

  depends_on 'tuntap'

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{sbin}/iodine", "-v"
  end
end
