class OpenMesh < Formula
  desc "Generic data structure to represent and manipulate polygonal meshes"
  homepage "http://openmesh.org"
  url "http://www.openmesh.org/media/Releases/4.0/OpenMesh-4.0.tar.gz"
  sha256 "93cdd9a7d41842fba39a6b53ec494d99127302d43e60812697a1397deeeff344"

  bottle do
    cellar :any
    sha256 "9ceb0b6d3509bb66bb88c24696bdbbee9a18fa49046efc14264385e3e4f15bcc" => :yosemite
    sha256 "583abd22356415032be1fb72bcf56f3fd5ad208a00351c7e37f07a080688b0cf" => :mavericks
    sha256 "b529044fa24d46f04a88f52fe26ab57f1b455e2b5bc71054b05c9aaeb5f8c029" => :mountain_lion
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
