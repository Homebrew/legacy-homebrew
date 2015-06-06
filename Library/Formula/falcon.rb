class Falcon < Formula
  desc "Multi-paradigm programming language and scripting engine"
  homepage "http://www.falconpl.org/"
  url "http://falconpl.org/project_dl/_official_rel/Falcon-0.9.6.8.tgz"
  sha256 "f4b00983e7f91a806675d906afd2d51dcee048f12ad3af4b1dadd92059fa44b9"

  head "http://git.falconpl.org/falcon.git"

  bottle do
    sha256 "b02169f29483d69cae65e365619a136696da26f035289628a5de0772e35dd580" => :yosemite
    sha256 "cad1d4cdd1d2704e6cc5741f39e0ce198ef9eb33c2b59dd56ca0617e88c12ecb" => :mavericks
    sha256 "c656eb21170196437124520c99ac71ace9ba7a8485553b27b147a1f17ab0ad2c" => :mountain_lion
  end

  option "with-editline", "Use editline instead of readline"
  option "with-feathers", "Include feathers (extra libraries)"

  deprecated_option "editline" => "with-editline"
  deprecated_option "feathers" => "with-feathers"

  depends_on "cmake" => :build
  depends_on "pcre"

  conflicts_with "sdl",
    :because => "Falcon optionally depends on SDL and then the build breaks. Fix it!"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DFALCON_BIN_DIR=#{bin}
      -DFALCON_LIB_DIR=#{lib}
      -DFALCON_MAN_DIR=#{man1}
      -DFALCON_WITH_INTERNAL_PCRE=OFF
      -DFALCON_WITH_MANPAGES=ON]

    if build.include? "editline"
      args << "-DFALCON_WITH_EDITLINE=ON"
    else
      args << "-DFALCON_WITH_EDITLINE=OFF"
    end

    if build.include? "feathers"
      args << "-DFALCON_WITH_FEATHERS=feathers"
    else
      args << "-DFALCON_WITH_FEATHERS=NO"
    end

    system "cmake", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<-EOS.undent
      looper = .[brigade
         .[{ val, text => oob( [val+1, "Changed"] ) }
           { val, text => val < 10 ? oob(1): "Homebrew" }]]
      final = looper( 1, "Original" )
      > "Final value is: ", final
    EOS

    assert_match(/Final value is: Homebrew/,
                 shell_output("#{bin}/falcon test").chomp)
  end
end
