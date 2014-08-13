require "formula"

class FbAdb < Formula
  homepage "https://github.com/facebook/fb-adb"
  url "https://github.com/facebook/fb-adb.git"
  sha1 ""

  depends_on 'android-ndk' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'pkg-config' => :build

  def install
    ENV['ANDROID_NDK'] = Formula['android-ndk'].opt_prefix

    system "./autogen.sh"

    mkdir 'build' do
      system "../configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/fb-adb", "version"
  end
end
