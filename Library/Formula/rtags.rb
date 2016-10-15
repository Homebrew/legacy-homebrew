
class Rtags < Formula
  homepage "https://github.com/Andersbakken/rtags"

  stable do
    url "https://github.com/Andersbakken/rtags/archive/v1.1.tar.gz"
    sha1 "305f722b4fa1fc06954be31483d01c129083de1c"

    resource "rct" do
      url "https://github.com/Andersbakken/rct.git", :revision => "39ee9faf055256b3942297b18117841d90bb0ef5"
    end
  end

  head "https://github.com/Andersbakken/rtags.git", :branch => "master"

  depends_on "cmake" => :build
  depends_on 'llvm' => 'with-clang'

  def install

    if build.head?
      system "git", "submodule", "init"
      system "git", "submodule", "update"
    else
      (buildpath/"src/rct").install resource("rct")
    end

    ENV.prepend "PATH", "#{opt_libexec}/llvm/bin:"

    mkdir "build" do
      args = std_cmake_args
      args << ".."
      if build.stable?
        args.delete("-DCMAKE_BUILD_TYPE=None")
      end

      system "cmake", *args
      system "make"
      system "make", "install"
    end

  end

end
