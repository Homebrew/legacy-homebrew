require 'formula'

class Libstxxl < Formula
  homepage 'http://stxxl.sourceforge.net/'
  url 'https://github.com/stxxl/stxxl/archive/1.4.0.tar.gz'
  sha1 '57230314bf136e477d6d96d0f68030af1f652278'

  # issue has been rectified in upstream and future 1.4.0 release
  depends_on 'cmake' => :build

  patch do
    url "https://github.com/stxxl/stxxl/commit/d23dd29b9492061a8da2201ab2585914b66bb9c3.diff"
    sha1 "af0e84a74f20047def5a76146057f3c176f12845"
  end

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_BUILD_TYPE=Release"
      system "make install"
    end
  end
end
