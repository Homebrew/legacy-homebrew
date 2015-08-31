class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "http://liballeg.org/"

  stable do
    url "https://downloads.sourceforge.net/project/alleg/allegro/5.0.11/allegro-5.0.11.tar.gz"
    sha256 "49fe14c9571463ba08db4ff778d1fbb15e49f9c33bdada3ac8599e04330ea531"
  end
  bottle do
    cellar :any
    revision 1
    sha256 "938c45ba6602727a4b524022387d13622718703f727fa6b1f1d94a0e3e3b357e" => :yosemite
    sha256 "c75ec1ca7b8b630283f8809607515eb4183d00f3e337ce12b8ef4f05525e1ccb" => :mavericks
    sha256 "f3cc83adca0beee9fb703f8566ecbffc2fbeba9a0315e09ddad28523b63728e4" => :mountain_lion
  end

  devel do
    url "https://downloads.sourceforge.net/project/alleg/allegro-unstable/5.1.11/allegro-5.1.11.tar.gz"
    sha256 "7a071635e39105ce52cd82c8641a8f3841efbdfe8fdb39f7a5ae1be6db3be07f"

    depends_on "theora" => :recommended
  end

  head do
    url "https://github.com/liballeg/allegro5.git", :branch => "5.1"

    depends_on "theora" => :recommended
  end

  depends_on "cmake" => :build
  depends_on "libvorbis" => :recommended
  depends_on "freetype" => :recommended
  depends_on "flac" => :recommended
  depends_on "physfs" => :recommended

  def install
    mkdir "build" do
      system "cmake", "..", "-DWANT_DOCS=OFF", *std_cmake_args
      system "make", "install"
    end
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
