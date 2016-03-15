class OpenMesh < Formula
  desc "Generic data structure to represent and manipulate polygonal meshes"
  homepage "http://openmesh.org"
  url "http://www.openmesh.org/media/Releases/5.1/OpenMesh-5.1.tar.gz"
  sha256 "643262dec62d1c2527950286739613a5b8d450943c601ecc42a817738556e6f7"

  bottle do
    cellar :any
    sha256 "fa6d5374f9464b1bf26ec5c2cdbc5178cfdf42659597eb5d2cd1fc272274b7c7" => :yosemite
    sha256 "575d33f851f7a359923e7667da77468034b9a11ced90f271ad4be80e49945b36" => :mavericks
    sha256 "02e3865ec6af79d2138a28ecd121f9974d3b0bb4769b0ec23cd52836d6fe225b" => :mountain_lion
  end

  head "http://openmesh.org/svnrepo/OpenMesh/trunk/", :using => :svn

  depends_on "cmake" => :build
  depends_on "qt" => :optional

  def install
    mkdir "build" do
      args = std_cmake_args

      if build.with? "qt"
        args << "-DBUILD_APPS=ON"
      else
        args << "-DBUILD_APPS=OFF"
      end

      system "cmake", "..", *args
      system "make", "install"
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
