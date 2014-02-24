require 'formula'

class Cairomm < Formula
  homepage 'http://cairographics.org/cairomm/'
  url 'http://cairographics.org/releases/cairomm-1.10.0.tar.gz'
  sha256 '068d96c43eae7b0a3d98648cbfc6fbd16acc385858e9ba6d37b5a47e4dba398f'

  bottle do
    sha1 "a755e155b8568e9345b0519fadc9cc0f1520e0a3" => :mavericks
    sha1 "7c4f267a6de185c1b2443d1e1e0b9522dd017064" => :mountain_lion
    sha1 "d93ad16013188911f8afe180dcfc6ea832f826f8" => :lion
  end

  option 'without-x', 'Build without X11 support'
  option :cxx11

  depends_on 'pkg-config' => :build
  if build.cxx11?
    depends_on 'libsigc++' => 'c++11'
  else
    depends_on 'libsigc++'
  end
  depends_on 'cairo'
  depends_on :x11 unless build.include? 'without-x'

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
