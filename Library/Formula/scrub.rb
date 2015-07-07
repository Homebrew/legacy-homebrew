class Scrub < Formula
  desc "Writes patterns on magnetic media to thwart data recovery"
  homepage "https://code.google.com/p/diskscrub/"
  url "https://github.com/chaos/scrub/releases/download/2.6.1/scrub-2.6.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/scrub/scrub_2.6.1.orig.tar.gz"
  sha256 "43d98d3795bc2de7920efe81ef2c5de4e9ed1f903c35c939a7d65adc416d6cb8"

  bottle do
    cellar :any
    sha256 "ceff54e0445d90ba0ae84700f5a1d5464f47a00f5d6447d2a408894bba1b3c80" => :yosemite
    sha256 "2b80cd482dd6ff2b9cdb3d730b06b5f3a7a1baa8e214026c63eeb8be410c20a7" => :mavericks
    sha256 "c713791e6a38ef18474678bbf12592cd69192cfd983f9344fbd76251579c25be" => :mountain_lion
  end

  head do
    url "https://github.com/chaos/scrub.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"foo.txt"
    path.write "foo"

    output = `#{bin}/scrub -r -p dod #{path}`
    assert output.include?("scrubbing #{path}")
    assert_equal 0, $?.exitstatus
    assert !File.exist?(path)
  end
end
