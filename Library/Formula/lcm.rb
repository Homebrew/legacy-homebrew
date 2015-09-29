class Lcm < Formula
  desc "libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/releases/download/v1.3.0/lcm-1.3.0.zip"
  sha256 "23bce19a4a6dc5df444d811f57796e14b4b0d1886cb3c219f90b72f328f2184e"

  head do
    url "https://github.com/lcm-proj/lcm.git"

    depends_on "xz" => :build
    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :java => :recommended
  depends_on :python => :optional
  depends_on :python3 => :optional

  def install
    ENV.java_cache

    if build.head?
      system "./bootstrap.sh"
    else
      # This deparallelize setting can be removed after an upstream release
      # that includes the revised makefile for the java part of LCM.
      #
      # (see https://github.com/lcm-proj/lcm/pull/48)
      #
      # Note that the pull request has been merged with the upstream master,
      # so it will be included in the next release of LCM.
      ENV.deparallelize
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"example_t.lcm").write <<-EOS.undent
      package exlcm;

      struct example_t
      {
          int64_t timestamp;
          double position[3];
          string name;
      }
    EOS
    system "#{bin}/lcm-gen", "-c", "example_t.lcm"
    assert(File.exist?("exlcm_example_t.h"), "lcm-gen did not generate C header file")
    assert(File.exist?("exlcm_example_t.c"), "lcm-gen did not generate C source file")
    system "#{bin}/lcm-gen", "-x", "example_t.lcm"
    assert(File.exist?("exlcm/example_t.hpp"), "lcm-gen did not generate C++ header file")
    if build.with? "java"
      system "#{bin}/lcm-gen", "-j", "example_t.lcm"
      assert(File.exist?("exlcm/example_t.java"), "lcm-gen did not generate java file")
    end
  end
end
