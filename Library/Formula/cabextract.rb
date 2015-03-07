class Cabextract < Formula
  homepage "http://www.cabextract.org.uk/"
  url "http://www.cabextract.org.uk/cabextract-1.5.tar.gz"
  sha1 "7ddb31072590a807bef09234f46f940e1ba51067"

  bottle do
    cellar :any
    sha1 "c7cd0a4500cfc35680ffa4687f9683bc741bbec0" => :yosemite
    sha1 "2367b8a88d18e528e1dded8425a8954e5402f472" => :mavericks
    sha1 "838d7c66e6447f79ea4b6bff4d7e29af1f25c5a9" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # probably the smallest valid .cab file
    cab = <<-EOS.gsub(/\s+/, "")
      4d5343460000000046000000000000002c000000000000000301010001000000d20400003
      e00000001000000000000000000000000003246899d200061000000000000000000
    EOS
    (testpath/"test.cab").binwrite [cab].pack("H*")

    system "#{bin}/cabextract", "test.cab"
    assert File.exist? "a"
  end
end
