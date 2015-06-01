class Allegro5 < Formula
  homepage "https://www.allegro.cc"
  url "https://downloads.sourceforge.net/project/alleg/allegro/5.0.11/allegro-5.0.11.tar.gz"
  sha256 "49fe14c9571463ba08db4ff778d1fbb15e49f9c33bdada3ac8599e04330ea531"

  head "git://git.code.sf.net/p/alleg/allegro", :branch => "5.1"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-versions"
    cellar :any
    sha256 "45bddf5bdb18bce6e99771c6e031ec89eeabc442a0dc45de72aa22e8e27b6193" => :yosemite
    sha256 "51014d2dafc31122b05db7b9a34264de6a9e5db50446b942d41cff4e22455590" => :mavericks
    sha256 "0ee8a23b7d169746a7323e2d61907fa0d096ab53c409bb0f7455ad85a82f1548" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "libvorbis" => :optional
  depends_on "freetype" => :optional
  depends_on "flac" => :optional
  depends_on "libpng" => :optional
  depends_on "jpeg" => :optional
  depends_on "physfs" => :optional

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
