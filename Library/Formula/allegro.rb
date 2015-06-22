class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "http://liballeg.org/"

  stable do
    url "https://downloads.sourceforge.net/project/alleg/allegro/5.0.11/allegro-5.0.11.tar.gz"
    sha256 "49fe14c9571463ba08db4ff778d1fbb15e49f9c33bdada3ac8599e04330ea531"
  end
  bottle do
    cellar :any
    sha256 "2b960b185c3458e8f9dc39ad80f7861ab4ab11cb18c118ce9d3c9ab13488a422" => :yosemite
    sha256 "762b4ba85b03478764ce857b905ca141843148a0ffe4f1a6b1e84640a6ce545d" => :mavericks
    sha256 "32a6ba24e889fb5529edcf6b6da894610942ce4610da8cb9ea021bf97ae13532" => :mountain_lion
  end

  devel do
    url "https://downloads.sourceforge.net/project/alleg/allegro-unstable/5.1.11/allegro-5.1.11.tar.gz"
    sha256 "7a071635e39105ce52cd82c8641a8f3841efbdfe8fdb39f7a5ae1be6db3be07f"

    depends_on "theora" => :recommended
  end

  head do
    url "git://git.code.sf.net/p/alleg/allegro", :branch => "5.1"

    depends_on "theora" => :recommended
  end

  depends_on "cmake" => :build
  depends_on "libvorbis" => :recommended
  depends_on "freetype" => :recommended
  depends_on "flac" => :recommended
  depends_on "libpng" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "physfs" => :recommended

  def install
    args = std_cmake_args + ["-DWANT_DOCS=OFF"]
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"allegro_test.cpp").write <<-EOS
    #include <assert.h>
    #include <allegro5/allegro5.h>

    int main(int n, char** c) {
      if (!al_init()) {
        return 1;
      }
      return 0;
    }
    EOS

    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lallegro", "-lallegro_main", "-o", "allegro_test", "allegro_test.cpp"
    system "./allegro_test"
  end
end
