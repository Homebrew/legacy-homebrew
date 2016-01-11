class Ragel < Formula
  desc "State machine compiler"
  homepage "https://www.colm.net/open-source/ragel/"
  url "https://www.colm.net/files/ragel/ragel-6.9.tar.gz"
  sha256 "6e07be0fab5ca1d9c2d9e177718a018fc666141f594a5d6e7025658620cf660a"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "7069ccbc6474e60eda037327a987329e6546e6ebcebd67cd851d9a530799fb14" => :el_capitan
    sha256 "0d7df494b183973c51cc1f8f3085924da718598661388c7065e5f8ead2f5c4ac" => :yosemite
    sha256 "0a086aa5126b989c3b40c0c3568f496803a66e612c61f938171addb8c06626e7" => :mavericks
  end

  resource "pdf" do
    url "https://www.colm.net/files/ragel/ragel-guide-6.9.pdf"
    sha256 "3f9406b0471facaf775c4d868fb545640d08f4df7ad9578db1e36ddef0afd608"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    doc.install resource("pdf")
  end

  test do
    testfile = testpath/"rubytest.rl"
    testfile.write <<-EOS.undent
    %%{
      machine homebrew_test;
      main := ( 'h' @ { puts "homebrew" }
              | 't' @ { puts "test" }
              )*;
    }%%
      data = 'ht'
      %% write data;
      %% write init;
      %% write exec;
    EOS
    system bin/"ragel", "-Rs", testfile
  end
end
