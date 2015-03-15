class RstudioServer < Formula
  homepage "http://www.rstudio.com"
  url "https://github.com/rstudio/rstudio/archive/v0.98.1103.tar.gz"
  sha256 "084049aae03cbaaa74a848f491d57cffab5ea67372ece0e256d54e04bd5fc6da"

  depends_on "ant" => :build
  depends_on "cmake" => :build
  depends_on "homebrew/science/r"
  depends_on "openssl"

  def install
    # some variables in rstudio installation scripts are hard coded, we have to change them
    # manually.
    # move the hard coded path to homebrew cellar
    inreplace "dependencies/common/install-boost", "/opt/rstudio-tools/boost", "#{prefix}/boost"
    inreplace "src/cpp/CMakeLists.txt", "/opt/rstudio-tools/boost", "#{prefix}/boost"
    # remove the unnecessary sudo
    inreplace "dependencies/common/install-boost", "sudo ", ""

    # install dependencies
    chdir "dependencies/common" do
      system "./install-packages"
      system "./install-dictionaries"
      system "./install-mathjax"
      system "./install-gwt"
      system "./install-boost"
      system "./install-pandoc"
    end

    mkdir "build" do
      system "cmake", "..",
        "-DRSTUDIO_TARGET=Server",
        "-DCMAKE_BUILD_TYPE=Release",
        "-DBOOST_ROOT=#{prefix}/boost/boost_1_50_0",
        "-DBoost_INCLUDE_DIR=#{prefix}/boost/boost_1_50_0/include",
        "-DCMAKE_INSTALL_PREFIX=#{prefix}/rstudio"
      system "make", "install"
    end

    bin.install_symlink prefix/"rstudio/bin/rserver" => "rstudio-server"
  end

  test do
    system "rstudio-server", "--help"
  end
end
