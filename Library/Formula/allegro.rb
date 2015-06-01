class Allegro < Formula
  desc "A multimedia library aimed at cross-platform game development"
  homepage "http://liballeg.org/"

  stable do
    url "https://downloads.sourceforge.net/project/alleg/allegro/5.0.11/allegro-5.0.11.tar.gz"
    sha256 "49fe14c9571463ba08db4ff778d1fbb15e49f9c33bdada3ac8599e04330ea531"
  end

  head do
    url "git://git.code.sf.net/p/alleg/allegro", :branch => "5.1"

    depends_on "theora" => :recommended
  end

  devel do
    url "https://downloads.sourceforge.net/project/alleg/allegro-unstable/5.1.10/allegro-5.1.10.tar.gz"
    sha256 "e8e8d604d60dc144022fd0af50a44bd9211fce87e7c150170209fa7b00d0ae8d"

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
