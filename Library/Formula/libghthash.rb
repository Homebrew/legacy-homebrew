class Libghthash < Formula
  desc "Generic hash table for C++"
  homepage "https://www.bth.se/people/ska/sim_home/libghthash.html"
  url "https://www.bth.se/people/ska/sim_home/filer/libghthash-0.6.2.tar.gz"
  sha256 "d1ccbb81f4c8afd7008f56ecb874f5cf497de480f49ee06929b4303d5852a7dd"

  bottle do
    cellar :any
    sha256 "0487e2e14b14ae288428c474fe9ce3e9baf814d4d73de8b0113ca9cc502ffd63" => :yosemite
    sha256 "207d07d59447e098c1987286324866ef8b26e0c4c191e4c1c0268ba8d95c5fac" => :mavericks
    sha256 "67fa9f1cda39b827ecd318a9f08980e322be034f00f198c0b7c83c2cf9a3d6a8" => :mountain_lion
  end

  option :universal

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    ENV.universal_binary if build.universal?
    system "autoreconf", "-ivf"
    system "./configure", "--disable-dependency-tracking",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <string.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <ght_hash_table.h>

      int main(int argc, char *argv[])
      {
        ght_hash_table_t *p_table;
        int *p_data;
        int *p_he;
        int result;

        p_table = ght_create(128);

        if ( !(p_data = (int*)malloc(sizeof(int))) ) {
          return 1;
        }

        *p_data = 15;

        ght_insert(p_table,
             p_data,
             sizeof(char)*strlen("blabla"), "blabla");

        if ( (p_he = ght_get(p_table,
                 sizeof(char)*strlen("blabla"), "blabla")) ) {
          result = 0;
        } else {
          result = 1;
        }
        ght_finalize(p_table);

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-lghthash", "-o", "test"
    system "./test"
  end
end
