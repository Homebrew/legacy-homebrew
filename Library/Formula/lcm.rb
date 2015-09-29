class Lcm < Formula
  desc "libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/releases/download/v1.2.1/lcm-1.2.1.zip"
  sha256 "55b959409fc1c0cfa705209b679dc4b3043b68f14078e192b65c1b6021c37ea6"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :java => :recommended
  depends_on "python3" => :optional

  def install
    # Make the directory for shared jars (if it doesn't already exist).
    # This way, we should get:
    #   /usr/local/share/java/lcm.jar -> /usr/local/Cellar/lcm/1.2.1/share/java/lcm.jar
    # instead of:
    #   /usr/local/share/java -> /usr/local/Cellar/lcm/1.2.1/share/java
    # and hopefully avoid conflicts with any other forumlae that install
    # shared jar files.
    mkpath "/usr/local/share/java"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "unzip -p /Library/Caches/Homebrew/lcm-1.2.1.zip lcm-1.2.1/examples/types/example_t.lcm > example_t.lcm"
    system "#{bin}/lcm-gen", "-c", "example_t.lcm"
    puts `ls -lah`
    # If you really want to test, look at the output of the header:
    # puts File.read("exlcm_example_t.h")
  end
end
