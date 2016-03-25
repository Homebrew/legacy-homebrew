class FbAdb < Formula
  desc "Shell for Android devices that does much of what adb does and more"
  homepage "https://github.com/facebook/fb-adb"
  url "https://github.com/facebook/fb-adb/archive/1.4.4.tar.gz"
  sha256 "c712cde3d4bfc16f8ea7da9a56d3cf567b8b9f1ae3c6c6bb052c95308b5752d9"

  bottle do
    cellar :any_skip_relocation
    sha256 "92dbb3db60e478549fe5dc3734c18e99e2c2b43e1c3e0d50728552f6efcade3f" => :el_capitan
    sha256 "ea7f04716e434f8788be5f00c321cf47aa0a0bfb988ccbe71a7772bcc8066794" => :yosemite
    sha256 "77f99858579778af72ba838f4372c5dd2064da10bc59fad5f3d680d29e474ca8" => :mavericks
    sha256 "1a70988d1082132abc28b6536ac2f4ae2b9cd13c1dc7f40f869b39023ce65e51" => :mountain_lion
  end

  depends_on "android-ndk" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "android-sdk"

  def install
    ENV["ANDROID_NDK"] = Formula["android-ndk"].opt_prefix

    system "./autogen.sh"

    mkdir "build" do
      system "../configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  def post_install
    system "echo", "Y", "|", "android", "update", "sdk", "--no-ui", "--filter", "platform-tools"
  end

  test do
    system "#{bin}/fb-adb", "devices"
    system "#{bin}/fb-adb", "kill-server"
    system "#{bin}/fb-adb", "start-server"
  end
end
