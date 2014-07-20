require "formula"

class Mercury < Formula
  homepage "http://mercurylang.org/"
  url "http://dl.mercurylang.org/release/mercury-srcdist-14.01.tar.gz"
  sha1 "619680675c68a0b953024b7ee4d3886a885d94de"

  bottle do
    sha1 "5fd50b21e04dc43853a2b55aa9fbeda7a222e324" => :mavericks
    sha1 "7f65e0c2a36a09078dbc1cf8091faaaf26b5e192" => :mountain_lion
    sha1 "07ef0c73fdbb8e928d02a6a78a5ce1f422623e53" => :lion
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
    args << "--enable-dotnet-grades" << "--enable-csharp-grade" if build.with? "mono"

    system "./configure", *args

    # The build system doesn't quite honour the mandir/infodir autoconf
    # parameters.
    system "make", "install", "PARALLEL=-j", "INSTALL_MAN_DIR=#{man}", "INSTALL_INFO_DIR=#{info}"

    # Remove batch files for windows.
    Dir.glob("#{bin}/*.bat") do |path|
      rm path
    end
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

    output = `#{testpath}/hello`
    assert_equal test_string, output
    assert_equal 0, $?.exitstatus
  end
end
