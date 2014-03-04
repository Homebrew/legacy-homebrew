require "formula"


class Jsoncpp < Formula
  homepage "http://sourceforge.net/projects/jsoncpp/"
  url "http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.6.0-rc2/jsoncpp-src-0.6.0-rc2.tar.gz"
  sha1 "a14eb501c44e610b8aaa2962bd1cc1775ed4fde2"

  depends_on 'scons' => :build 
  
  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    system "scons", "platform=linux-gcc"
    lib.install Pathname.glob("libs/*/libj*dylib") => "libjsoncpp.dylib"
    lib.install Pathname.glob("libs/*/libj*a") => "libjsoncpp.a"
    cd 'include' do
      include.install "json"
    end
  end

  test do
    system "otool", "-L" , "#{lib}/libjsoncpp.dylib"
  end
end
