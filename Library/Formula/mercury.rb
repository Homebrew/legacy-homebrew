class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "http://dl.mercurylang.org/release/mercury-srcdist-14.01.1.tar.gz"
  sha256 "98f7cbde7a7425365400feef3e69f1d6a848b25dc56ba959050523d546c4e88b"

  bottle do
    sha256 "cd513a5ca92a2dc2162db2f87208129cb5b3ab0ce6d85e0da0c4b54498278144" => :yosemite
    sha256 "bcf3147bb1480f1f99f4af7b43a0b4a217b7f2192ec621c8b2c6777a4df8dba3" => :mavericks
    sha256 "ebef2e58fbf08029606fba423f6e689231af0fe2d96f3baff270f1a47ed2003c" => :mountain_lion
  end

  depends_on "erlang" => :optional
  depends_on "homebrew/science/hwloc" => :optional
  depends_on "mono" => :optional

  def install
    args = ["--prefix=#{prefix}",
            "--mandir=#{man}",
            "--infodir=#{info}",
            "--disable-dependency-tracking",
            "--enable-java-grade"]

    args << "--enable-erlang-grade" if build.with? "erlang"
    args << "--with-hwloc" if build.with? "hwloc"
    args << "--enable-csharp-grade" if build.with? "mono"

    system "./configure", *args

    # The build system doesn't quite honour the mandir/infodir autoconf
    # parameters.
    system "make", "install", "PARALLEL=-j",
                              "INSTALL_MAN_DIR=#{man}",
                              "INSTALL_INFO_DIR=#{info}"

    # Remove batch files for windows.
    rm Dir.glob("#{bin}/*.bat")
  end

  test do
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.m"
    path.write <<-EOS
      :- module hello.
      :- interface.
      :- import_module io.
      :- pred main(io::di, io::uo) is det.
      :- implementation.
      main(IOState_in, IOState_out) :-
          io.write_string("#{test_string}", IOState_in, IOState_out).
    EOS
    system "#{bin}/mmc", "--make", "hello"
    assert File.exist?(testpath/"hello")

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
