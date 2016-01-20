class Cycript < Formula
  desc "Modify apps using a hybrid of Objective-C++ and JavaScript syntax."
  homepage "http://www.cycript.org"
  url "git://git.saurik.com/cycript.git",
    :tag => "v0.9.592",
    :revision => "97bec96b43b66ab78af95d2b6c6c24f0d0a8006a"

  head "git://git.saurik.com/cycript.git"

  depends_on "bison" => :build
  depends_on "android-sdk" => :build
  depends_on "readline"

  def install
    ENV.append "CPPFLAGS", "-Wno-inconsistent-missing-override"

    system "./configure",
           "--prefix=#{libexec}",
           "CPPFLAGS=#{ENV.cppflags}"

    system "make", "install"

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "7", pipe_output("#{bin}/cycript -", "print([@[@2,@3].map(a => a + 1) valueForKeyPath:@\"@sum.self\"])").strip, "The basic interpreter is not functioning correctly"
    assert_not_equal 0, pipe_output("#{bin}/cycript -", "process.pid").strip.to_i, "process.pid is undefined which means that libcycript.cy could not be found"
    assert_equal "(typedef SEL)", pipe_output("#{bin}/cycript -", "typeid(sel_registerName(\"description\"))").strip, "The Objective-C runtime functions are not defined in Cycript which means that libcycript.db could not be found"
  end
end
