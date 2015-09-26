class Ragel < Formula
  desc "State machine compiler"
  homepage "http://www.colm.net/ragel/"
  url "http://www.colm.net/files/ragel/ragel-6.9.tar.gz"
  sha256 "6e07be0fab5ca1d9c2d9e177718a018fc666141f594a5d6e7025658620cf660a"

  bottle do
    cellar :any
    sha1 "9cde046f905a7f9d31158860974209c6dbaa3576" => :mavericks
    sha1 "d5a7d2e3cd213a466dd5ed3681f9e5bc04745353" => :mountain_lion
    sha1 "0394a21200234fe66535505ae8ab7cdfdc354f84" => :lion
  end

  resource "pdf" do
    url "http://www.colm.net/files/ragel/ragel-guide-6.9.pdf"
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
    system "ragel", "-Rs", testfile
  end
end
