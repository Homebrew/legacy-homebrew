require 'formula'

class Aspcud < Formula
  desc "Package dependency solver"
  homepage 'http://potassco.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/potassco/aspcud/1.9.0/aspcud-1.9.0-source.tar.gz'
  sha1 'ae77772c2424620b3064d0dfe795c26b1c8aa778'

  bottle do
    revision 1
    sha1 "9d08bb4dfab9afd90b0ca3b3b3f48733869670a6" => :mavericks
    sha1 "dc6c376297ce949034d67b4f8760b67427e9d60b" => :mountain_lion
    sha1 "705c19c367ee0740eaa0d8130e0619d0879d7db5" => :lion
  end

  depends_on 'boost' => :build
  depends_on 'cmake' => :build
  depends_on 're2c'  => :build
  depends_on 'gringo'
  depends_on 'clasp'

  # boost 1.56 compatibility
  # https://sourceforge.net/p/potassco/bugs/99/
  patch :DATA

  def install
    mkdir "build" do
      system "cmake", "..", "-DGRINGO_LOC=#{Formula["gringo"].opt_bin}/gringo", "-DCLASP_LOC=#{Formula["clasp"].opt_bin}/clasp", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
   fixture = <<-EOS.undent
      package: foo
      version: 1

      request: foo >= 1
    EOS
    (testpath/'in.cudf').write(fixture)
    system "#{bin}/aspcud", "in.cudf", "out.cudf"
  end
end
__END__
diff --git a/libcudf/src/dependency.cpp b/libcudf/src/dependency.cpp
index 37e7a93..519f2f6 100644
--- a/libcudf/src/dependency.cpp
+++ b/libcudf/src/dependency.cpp
@@ -49,7 +49,7 @@ namespace {

     struct CudfPackageRefFilter {
         CudfPackageRefFilter(const Cudf::PackageRef &ref) : ref(&ref) { }
-        bool operator()(const Entity *entity) {
+        bool operator()(const Entity *entity) const {
             switch (ref->op) {
                 case Cudf::PackageRef::EQ:
                     return (entity->version == ref->version || entity->allVersions()) && ref->version != 0;
