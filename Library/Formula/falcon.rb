class Falcon < Formula
  desc "Multi-paradigm programming language and scripting engine"
  homepage "http://www.falconpl.org/"
  url "http://falconpl.org/project_dl/_official_rel/Falcon-0.9.6.8.tgz"
  sha256 "f4b00983e7f91a806675d906afd2d51dcee048f12ad3af4b1dadd92059fa44b9"

  head "http://git.falconpl.org/falcon.git"

  bottle do
    revision 1
    sha256 "48f3fc7a4ee3f479b0dafae18262cb900d64f43f5a3f2fa32727b65f6836f81e" => :el_capitan
    sha256 "e5dc11f9529c43c216dc304df212eab022ce654fc551ad244a291a6b861931b8" => :yosemite
    sha256 "bf2a677c2d6777b577bffc22d3c75a65525700bef6478035dececa002e5e11ec" => :mavericks
    sha256 "9730e050c70ad2803afdf9cd03b108b8c4bb57b797bd92595523ad0731639b81" => :mountain_lion
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
      -DFALCON_BIN_DIR=#{bin}
      -DFALCON_LIB_DIR=#{lib}
      -DFALCON_MAN_DIR=#{man1}
      -DFALCON_WITH_INTERNAL_PCRE=OFF
      -DFALCON_WITH_MANPAGES=ON]

    if build.with? "editline"
      args << "-DFALCON_WITH_EDITLINE=ON"
    else
      args << "-DFALCON_WITH_EDITLINE=OFF"
    end

    if build.with? "feathers"
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
