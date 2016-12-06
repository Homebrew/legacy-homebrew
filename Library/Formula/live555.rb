require 'formula'

class Live555 < Formula
  homepage 'http://www.live555.com/liveMedia/'
  url 'http://live555sourcecontrol.googlecode.com/files/live.2011.12.23.tar.gz'
  sha1 '665b7542da1f719b929d51842f39474ef340d9f6'

  head 'http://www.live555.com/liveMedia/public/live555-latest.tar.gz'

  depends_on 'cmake' => :build

  conflicts_with 'openrtsp',
    :because => 'both openrtsp and live555 install binaries with the same name'

  #Add CMakeLists.txt to make it easy to install specially for the older version that does not have a make install task
  def patches
    { :p1 => 'https://gist.github.com/nandub/2078dc43b068ef5b8ef9/raw/ae02204a1f790add0b375b5160863c215450c8d4/0001-live555-cmakefile' }
  end

  def install
    args = std_cmake_args
    if build.head?
      args << "-DLATEST_VERSION=ON"
    else
      args << "-DLATEST_VERSION=OFF"
    end

    mkdir 'build' do
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end

  def test
    system "#{bin}/openRTSP 2>&1 | grep -q startPortNum"
  end
end
