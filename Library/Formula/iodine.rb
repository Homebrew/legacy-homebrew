class Iodine < Formula
  desc "Tool for tunneling IPv4 data through a DNS server"
  homepage "http://code.kryo.se/iodine/"
  head "https://github.com/yarrick/iodine.git"

  stable do
    url "http://code.kryo.se/iodine/iodine-0.7.0.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/iodine/iodine_0.7.0.orig.tar.gz"
    sha256 "ad2b40acf1421316ec15800dcde0f587ab31d7d6f891fa8b9967c4ded93c013e"

    depends_on :tuntap
  end

  bottle do
    cellar :any
    revision 1
    sha256 "4bb3858d87351246c6786ddf1f3c09f9f266c83087b6f31755f2c1b610325718" => :mavericks
    sha256 "371c3443aeebef21ec9ec072e2bcc472bd76d4909466744c66f67a9bbce5d41f" => :mountain_lion
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{sbin}/iodine", "-v"
  end
end
