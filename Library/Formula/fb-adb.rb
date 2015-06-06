class FbAdb < Formula
  desc "Shell for Android devices that does much of what adb does and more"
  homepage "https://github.com/facebook/fb-adb"
  url "https://github.com/facebook/fb-adb/archive/1.2.0.tar.gz"
  sha1 "a86939f72c8c52c2fc7bc2ec756f179863076622"

  bottle do
    cellar :any
    sha1 "21d0566e25712be5e04caa8c23980e80575abda7" => :yosemite
    sha1 "336e8fcd1b4061d2a62bc04a7581be46b85736c1" => :mavericks
    sha1 "19f9cd0ae30d27ea80e42808bbf9803bdd10d548" => :mountain_lion
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
