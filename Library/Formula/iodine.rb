require 'formula'

class Iodine < Formula
  homepage 'http://code.kryo.se/iodine/'
  url 'http://code.kryo.se/iodine/iodine-0.7.0.tar.gz'
  sha1 'f4c49305b6f46a547b160b3bd8c962942d701a63'
  depends_on 'tuntap'

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{sbin}/iodine", "-v"
  end
end
