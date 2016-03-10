class Libdsk < Formula
  desc "Library for accessing discs and disc image files"
  homepage "http://www.seasip.info/Unix/LibDsk/"
  url "http://www.seasip.info/Unix/LibDsk/libdsk-1.4.0.tar.gz"
  sha256 "645612159ad9a990183f8f80876e686e185d6b6aa7f2ddd623da22f314563f64"

  bottle do
    sha256 "5b826726a3146916ec472d350c00656e878b0420d271b4c623d868fd91809637" => :yosemite
    sha256 "2992e58a9f040643f6c582057d72d4a8af67d18b0fca6ec605b8d06ecc7fb82b" => :mavericks
    sha256 "8b36ee07409e81ea6fe3fa72b43f7b8a025180ffbcf8eade58a48053330b3312" => :mountain_lion
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
