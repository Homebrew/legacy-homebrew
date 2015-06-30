class OpenMesh < Formula
  desc "Generic data structure to represent and manipulate polygonal meshes"
  homepage "http://openmesh.org"
  url "http://www.openmesh.org/media/Releases/4.0/OpenMesh-4.0.tar.gz"
  sha256 "93cdd9a7d41842fba39a6b53ec494d99127302d43e60812697a1397deeeff344"

  bottle do
    cellar :any
    sha256 "e4bc6932d6a585fa96b9cc8f09c3037d852dae79072a8feea47612ba48598212" => :yosemite
    sha256 "7806df7d4f499a801350087017944a79365336aec3b266bb5bee2ef17ffa017a" => :mavericks
    sha256 "0ca60ff704a7d442bdd432d9a63f58d2e453d787648f3831bcaa27ac2f5a1114" => :mountain_lion
  end

  head "http://openmesh.org/svnrepo/OpenMesh/trunk/", :using => :svn

  depends_on "cmake" => :build
  depends_on "qt" => :optional

  # For 4.0 version, when BUILD_APPS=OFF, the fixbundle.cmake will not be
  # generated for a lacking cmake command `configure_file`.
  # the oirinal patch for version 3.3 is submitted to openmesh-bounces@lists.rwth-aachen.de on July 8, 2015.
  # And the bug has been confirmed from upstream by moebius@cs.rwth-aachen.de on July 24.
  # The cmakelists.txt is patched a little by adding the missing line to
  # generate the fixbundle file even when build app. option is off. Another way
  # (cleaner way) is to disable customized target option.
  patch do
    url "https://gist.githubusercontent.com/autosquid/d41d6348bbf028c4d6f8/raw/1f9296b81b998e73f9980f7504460fc3bc00b030/CMakeLists.patch"
    sha256 "19a795c9e0760085944470f5c3baf846edb251be20ff5cc7c24d0e2b47244c36"
  end


  def install
    mkdir "build" do
      args = std_cmake_args
      if build.with? "qt"
        args << "-DBUILD_APPS=ON"
      else
        args << "-DBUILD_APPS=OFF"
      end
      system "cmake", "..", *args
      system "make install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
    #include <iostream>
    #include <OpenMesh/Core/IO/MeshIO.hh>
    #include <OpenMesh/Core/Mesh/PolyMesh_ArrayKernelT.hh>
    typedef OpenMesh::PolyMesh_ArrayKernelT<>  MyMesh;
    int main()
    {
        MyMesh mesh;
        MyMesh::VertexHandle vhandle[4];
        vhandle[0] = mesh.add_vertex(MyMesh::Point(-1, -1,  1));
        vhandle[1] = mesh.add_vertex(MyMesh::Point( 1, -1,  1));
        vhandle[2] = mesh.add_vertex(MyMesh::Point( 1,  1,  1));
        vhandle[3] = mesh.add_vertex(MyMesh::Point(-1,  1,  1));
        std::vector<MyMesh::VertexHandle>  face_vhandles;
        face_vhandles.clear();
        face_vhandles.push_back(vhandle[0]);
        face_vhandles.push_back(vhandle[1]);
        face_vhandles.push_back(vhandle[2]);
        face_vhandles.push_back(vhandle[3]);
        mesh.add_face(face_vhandles);
        try
        {
        if ( !OpenMesh::IO::write_mesh(mesh, "triangle.off") )
        {
            std::cerr << "Cannot write mesh to file 'triangle.off'" << std::endl;
            return 1;
        }
        }
        catch( std::exception& x )
        {
        std::cerr << x.what() << std::endl;
        return 1;
        }
        return 0;
    }

    EOS
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[ -I#{include} -L#{lib} -lOpenMeshCore -lOpenMeshTools]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"

  end
end
