class Libdsk < Formula
  desc "Library for accessing discs and disc image files"
  homepage "http://www.seasip.info/Unix/LibDsk/"
  url "http://www.seasip.info/Unix/LibDsk/libdsk-1.4.0.tar.gz"
  sha256 "645612159ad9a990183f8f80876e686e185d6b6aa7f2ddd623da22f314563f64"

  bottle do
    sha256 "8ed498f088ad97d88d267351a8c90f9db54ac2f42e6670e5f4bda2eb20864852" => :el_capitan
    sha256 "3e17fa4773145ca69db2ba8f36165b9a5f041a297a01b17a9692218790a5aa38" => :yosemite
    sha256 "b1406d66e802413b7999190502ee986931f4c91f48c76ac6520506640a1c1dd5" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    doc.install Dir["doc/*.{html,pdf,sample,txt}"]
  end

  test do
    assert_equal "#{name} version #{version}\n", shell_output(bin/"dskutil --version")
  end
end
