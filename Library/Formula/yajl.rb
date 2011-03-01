require 'formula'

class Yajl <Formula
  homepage 'http://lloyd.github.com/yajl/'
  url 'http://github.com/lloyd/yajl/tarball/1.0.11'
  md5 '5b60f4d59b3b1fb42d7808d08460fb12'

  def patches
    # All YAJL releases so far have an rpath bug, though its fixed in upstream git:
    "https://github.com/lloyd/yajl/commit/a31c4d0f9ad90b4b58508702fd877bb35039067e.patch"
  end

  # Configure uses cmake, even though it looks like we're
  # just using autotools below.
  depends_on 'cmake' => :build

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make install"
    (include + 'yajl').install Dir['src/api/*.h']
  end
end
