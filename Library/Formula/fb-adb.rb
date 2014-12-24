class FbAdb < Formula
  homepage "https://github.com/facebook/fb-adb"
  url "https://github.com/facebook/fb-adb/archive/1.2.0.tar.gz"
  sha1 "a86939f72c8c52c2fc7bc2ec756f179863076622"

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
