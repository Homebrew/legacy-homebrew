class Glslang < Formula
  desc "glslang is an OpenGL and OpenGL ES shader front end and validator."
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/3.0.tar.gz"
  sha256 "91653d09a90440a0bc35aa490d0c44973501257577451d4c445b2df5e78d118c"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"

      # Version 3.0 of glslang does not respect the overridden CMAKE_INSTALL_PREFIX. This has
      # been fixed in master [1] so when that is released, the manual install commands should
      # be removed.
      #
      # 1. https://github.com/KhronosGroup/glslang/commit/4cbf748b133aef3e2532b9970d7365304347117a
      bin.install Dir["install/bin/*"]
      lib.install Dir["install/lib/*"]
    end
  end

  test do
    (testpath/"test.frag").write <<-EOS.undent
      #version 110
      void main() {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
      }
    EOS
    (testpath/"test.vert").write <<-EOS.undent
      #version 110
      void main() {
          gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
      }
    EOS
    system "#{bin}/glslangValidator", "-i", testpath/"test.vert", testpath/"test.frag"
  end
end
