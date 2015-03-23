class SeafileClient < Formula
  desc "Open source cloud storage application"
  homepage "http://www.seafile.com/"
  url "https://github.com/haiwen/seafile-client/archive/v4.2.8.tar.gz"
  sha256 "d245f74fb4fd95c2639de248347efdab2968f1533eabda9889e336ace346fbd8"

  head "https://github.com/haiwen/seafile-client.git"

  option "without-app", "Build without app bundle"

  # Seafile Client doesn't support OS X older than lion since version 4.0.
  # It uses some features that don't come along with OS X 10.6.
  depends_on MinimumMacOSRequirement => :lion

  depends_on :xcode => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "jansson"
  depends_on "qt5"
  depends_on "openssl"
  depends_on "libsearpc"
  depends_on "ccnet"
  depends_on "seafile"

  def install
    ENV.cxx11
    cmake_args = std_cmake_args
    if build.with? "app"
      # use the build script to generate app bundle
      cmake_args << "-G" << "Xcode" << "-DCMAKE_BUILD_TYPE=Release"
      system "cmake", ".", *cmake_args
      xcodebuild "-target", "ALL_BUILD", "-configuration", "Release", "SYMROOT=."

      File.rename "Release/seafile-applet.app", "Seafile Client.app"

      # Install app bundle
      prefix.install "Seafile Client.app"

      # Create necessary symbol links which are used by Seafile Client
      resources_directory = prefix/"Seafile Client.app/Contents/Resources"
      mkdir_p resources_directory
      resources_directory.install_symlink "#{Formula["ccnet"].opt_prefix}/bin/ccnet"
      resources_directory.install_symlink "#{Formula["seafile"].opt_prefix}/bin/seaf-daemon"

      # Create symbol links to be executed from the console
      bin.install_symlink prefix/"Seafile Client.app/Contents/MacOS/seafile-applet"
    else
      system "cmake", ".", *cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    # this command will connect the running seaf-daemon and ask it to quit
    system "#{bin}/seafile-applet", "-K"
  end
end
