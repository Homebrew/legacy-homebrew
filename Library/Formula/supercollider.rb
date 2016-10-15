
class Supercollider < Formula
  homepage "https://supercollider.github.io"
  url "https://github.com/supercollider/supercollider.git",
    :tag => "after-qt5",
    :revision => "085cab288947fe06f468117f5c294db516b2afc0"
  sha256 "80956465c2637cf0cc67c3550900e2f392d10d33f2518c25bbb9332901ae226c"

  version "3.7-devel"

  depends_on :xcode => :build
  depends_on :macos => :lion
  depends_on "cmake" => :build
  depends_on "qt5" => :build
  depends_on "readline" => :build

  def install
    ENV.deparallelize
    bp = buildpath/"build"
    mkdir_p bp
    # std_cmake_args +
    args = [
      "-G", "Xcode",
      "-DCMAKE_PREFIX_PATH=#{Formula["qt5"].opt_prefix}",
      "-DSC_QT=1",
      "-DREADLINE_INCLUDE_DIR=#{Formula["readline"].opt_include}",
      "-DREADLINE_LIBRARY=#{Formula["readline"].opt_lib}/libreadline.dylib",
      ".."
    ]

    cd bp do
      system "cmake", *args
      xcodebuild "-target", "install",
                "-configuration", "Release"
    end

    prefix.install "build/Install/SuperCollider"

    # Install sclang and scsynth binaries.
    # sclang and scsynth need to be executed in the bundle
    # or the dynamic linking to the Qt libraries gets confused.
    # write_exec_script creates a wrapper to exec it
    bin.write_exec_script prefix/"SuperCollider/SuperCollider.app/Contents/MacOS/sclang"
    bin.write_exec_script prefix/"SuperCollider/SuperCollider.app/Contents/MacOS/scsynth"
  end

  test do
    assert File.exist?("#{prefix}/SuperCollider.app")
    assert File.exist?("#{bin}/sclang")
    assert File.exist?("#{bin}/scsynth")
    # when -V is implemented in sclang then we can run the process
    # system "#{bin}/sclang", "-V"
  end
end
