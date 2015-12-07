class Gasnet < Formula
  desc "Global-Address Space Networking layer and communication primitives"
  homepage "http://gasnet.lbl.gov"
  url "http://gasnet.lbl.gov/GASNet-1.26.0.tar.gz"
  mirror "https://bitbucket.org/berkeleylab/gasnet/downloads/GASNet-1.26.0.tar.gz"
  sha256 "32b84c47910c36137db198a9c5396dd0a87c29ad72f2040493aa9e8b2a24f929"

  head do
    url "https://bitbucket.org/berkeleylab/gasnet.git"

    depends_on "autoconf"   => :build
    depends_on "automake"   => :build
    depends_on "libtool"    => :build
    depends_on "pkg-config" => :build
  end

  option "without-test", "Skip build time tests (requires properly configured MPI and firewall settings)"

  depends_on :mpi => [:cc, :cxx]

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "run-tests" if build.with? "test"
    (pkgshare/"test").install "tests/testhello.c"
    system "make", "install"
  end

  test do
    # GASNet requires us to use makefiles specialized for each "conduit"
    # On MAC OS X we have an MPI implementation so write a makefile to
    # test the above program over that conduit
    (testpath/"makefile").write <<-EOS.undent
      include #{opt_include}/mpi-conduit/mpi-par.mak
      test: testhello
      \t#{bin}/gasnetrun_mpi -n 3 $^
      .PHONY: test
      testhello.o: #{pkgshare}/test/testhello.c
      \t$(GASNET_CC) $(GASNET_CPPFLAGS) $(GASNET_CFLAGS) -c -o $@ $<
      testhello: testhello.o
      \t$(GASNET_LD) $(GASNET_LDFLAGS) -o $@ $< $(GASNET_LIBS)
    EOS
    system "make", "test"
  end
end
