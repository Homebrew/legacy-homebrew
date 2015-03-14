
class Supercollider < Formula
  homepage "https://supercollider.github.io"
  url "https://github.com/supercollider/supercollider.git"

  depends_on :xcode => :build
  depends_on :macos => :lion
  depends_on "cmake" => :build
  depends_on "qt5" => :build
  depends_on "readline" => :build

  version "3.7-devel"

  def install
    ENV.deparallelize
    bp = buildpath/"build"
    mkdir_p bp
    # std_cmake_args +
    args = [
      "-G", "Xcode",
      "-DCMAKE_PREFIX_PATH=#{Formula['qt5'].opt_prefix}",
      "-DSC_QT=1",
      # defaults to the user's OS
      # "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.7",
      "-DREADLINE_INCLUDE_DIR=#{Formula['readline'].opt_include}",
      "-DREADLINE_LIBRARY=#{Formula['readline'].opt_lib}/libreadline.dylib",
      ".."
    ]

    cd bp do
      system "cmake", *args
      xcodebuild "-target", "install",
                "-configuration", "Release"
                # "SYMROOT=#{bp}" -- fails
    end

    # Copy the app into the cellar
    # User should then run `brew linkapps supercollider`
    # to install it into /Applications
    cp_r "./build/Install/SuperCollider/SuperCollider.app", prefix/"SuperCollider.app"

    # Install sclang and scsynth binaries.
    # sclang and scsynth need to be executed in the bundle
    # or the dynamic linking to the Qt libraries gets confused.
    # write_exec_script creates a wrapper to exec it
    bin.write_exec_script prefix/"SuperCollider.app/Contents/MacOS/sclang"
    bin.write_exec_script prefix/"SuperCollider.app/Contents/MacOS/scsynth"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    assert File.exist?("#{prefix}/SuperCollider.app")
    assert File.exist?("#{bin}/sclang")
    assert File.exist?("#{bin}/scsynth")
    # when -V is implemented in sclang then we can run the process
    # system "#{bin}/sclang", "-V"
  end

end
