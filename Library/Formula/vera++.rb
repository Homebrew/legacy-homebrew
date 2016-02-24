class Veraxx < Formula
  desc "Programmable tool for C++ source code"
  homepage "https://bitbucket.org/verateam/vera"
  url "https://bitbucket.org/verateam/vera/downloads/vera++-1.3.0.tar.gz"
  sha256 "9415657a09438353489db10ca860dd6459e446cfd9c649a1a2e02268da66f270"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "76dcb0b9340b8fc9413fc848dff27e8805d7b2a9c63d5128fc83ce5bd3bd1cd5" => :el_capitan
    sha256 "a2620392e9204964ecd0ec0bc6b90268d27e5e2a28ef304aff3d3719ed058b80" => :yosemite
    sha256 "05d5ff89c4ce8aa8054a94d234824fff41cd9f16e029022096c1d99301c9e572" => :mavericks
  end

  depends_on "cmake" => :build

  # Use prebuilt docs to avoid need for pandoc
  resource "doc" do
    url "https://bitbucket.org/verateam/vera/downloads/vera++-1.3.0-doc.tar.gz"
    sha256 "122a15e33a54265d62a6894974ca2f0a8f6ff98742cf8e6152d310cc23099400"
  end

  # Custom-built boost, lua, and luabind are used by the build scripts
  resource "boost" do
    url "https://downloads.sourceforge.net/project/boost/boost/1.56.0/boost_1_56_0.tar.bz2"
    sha256 "134732acaf3a6e7eba85988118d943f0fa6b7f0850f65131fff89823ad30ff1d"
  end

 resource "lua" do
   url "https://github.com/LuaDist/lua/archive/5.2.3.tar.gz"
   sha256 "c8aa2c74e8f31861cea8f030ece6b6cb18974477bd1e9e1db4c01aee8f18f5b6"
 end

 resource "luabind" do
   url "https://github.com/verateam/luabind/archive/vera-1.3.0.tar.gz"
   sha256 "7d93908b7d978e44ebe5dfad6624e6daa033f284a5f24013f37cac162a18f71a"
 end

  def install
    resource("boost").stage do
      system "./bootstrap.sh", "--prefix=#{buildpath}/3rdParty",
             "--with-libraries=filesystem,system,program_options,regex,wave,python"
      system "./b2", "install", "threading=multi", "link=static", "warnings=off",
             "cxxflags=-DBOOST_WAVE_SUPPORT_MS_EXTENSIONS=1", "-s NO_BZIP2=1"
    end

    resource("lua").stage do
      args = std_cmake_args
      args << "-DBUILD_SHARED_LIBS:BOOL=OFF"
      args << "-DCMAKE_INSTALL_PREFIX:PATH=#{buildpath}/3rdParty"
      system "cmake", ".", *args
      system "make", "install"
    end

    resource("luabind").stage do
      args = std_cmake_args
      args << "-DBUILD_TESTING:BOOL=OFF"
      args << "-DLUA_INCLUDE_DIR:PATH=#{buildpath}/3rdParty/include"
      args << "-DLUA_LIBRARIES:PATH=#{buildpath}/3rdParty/lib/liblua.a"
      args << "-DBOOST_ROOT:PATH=#{buildpath}/3rdParty"
      args << "-DCMAKE_INSTALL_PREFIX:PATH=#{buildpath}/3rdParty"
      system "cmake", ".", *args
      system "make", "install"
    end

    system "cmake", ".",
           "-DVERA_USE_SYSTEM_BOOST:BOOL=ON", "-DBoost_USE_STATIC_LIBS:BOOL=ON",
           "-DLUA_INCLUDE_DIR:PATH=#{buildpath}/3rdParty/include",
           "-DLUA_LIBRARIES:PATH=#{buildpath}/3rdParty/lib/liblua.a",
           "-DLUA_LIBRARY:PATH=#{buildpath}/3rdParty/lib/liblua.a",
           "-DLUABIND_INCLUDE_DIR:PATH=#{buildpath}/3rdParty/include",
           "-DLUABIND_LIBRARIES:PATH=#{buildpath}/3rdParty/lib/libluabind.a",
           "-DLUABIND_LIBRARY:PATH=#{buildpath}/3rdParty/lib/libluabind.a",
           "-DBoost_INCLUDE_DIR:PATH=#{buildpath}/3rdParty/include",
           "-DBoost_LIBRARY_DIR_RELEASE:PATH=#{buildpath}/3rdParty/lib",
           *std_cmake_args
    system "make", "install"
    system "ctest"

    resource("doc").stage do
      man1.install "vera++.1"
      doc.install "vera++.html"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/vera++ --version").strip
  end
end
