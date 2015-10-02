class Mongrel2 < Formula
  desc "Application, language, and network architecture agnostic web server"
  homepage "http://mongrel2.org/"
  url "https://github.com/mongrel2/mongrel2/releases/download/v1.9.3/mongrel2-v1.9.3.tar.bz2"
  sha256 "40ee0e804053f812cc36906464289ea656a4fc53b4a82d49796cafbe37f97425"

  head "https://github.com/mongrel2/mongrel2.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "7ec33fab8c9e95f1d83fdd72b3209773d76dd7ef08134214a7e51f1b20969f03" => :yosemite
    sha256 "f8b15e5f50d29e955763111079b6715c6cbd8531ef6b9aa13f514a9c774e5f43" => :mavericks
    sha256 "2bdf0a2207bc8aac4c02638cad6febadcef6f473bc324f15d2f31c013b3b7707" => :mountain_lion
  end

  depends_on "zeromq"

  # Fix #43925 by backporting fix to 1.9.3. Remove when 1.9.4 comes out.
  # https://github.com/mongrel2/mongrel2/pull/274
  patch :DATA

  def install
    # Build in serial. See:
    # https://github.com/Homebrew/homebrew/issues/8719
    ENV.j1

    # Mongrel2 pulls from these ENV vars instead
    ENV["OPTFLAGS"] = "#{ENV.cflags} #{ENV.cppflags}"
    ENV["OPTLIBS"] = "#{ENV.ldflags} -undefined dynamic_lookup"

    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"m2sh", "help"
  end
end

__END__
diff --git a/src/mem/align.h b/src/mem/align.h
index 4c6e183..03a4999 100644
--- a/src/mem/align.h
+++ b/src/mem/align.h
@@ -30,7 +30,7 @@ union max_align
	void (*q)(void);
 };

-typedef union max_align max_align_t;
+typedef union max_align h_max_align_t;

 #endif

diff --git a/src/mem/halloc.c b/src/mem/halloc.c
index b097d1f..40d0c09 100644
--- a/src/mem/halloc.c
+++ b/src/mem/halloc.c
@@ -34,7 +34,7 @@ typedef struct hblock
 #endif
	hlist_item_t  siblings; /* 2 pointers */
	hlist_head_t  children; /* 1 pointer  */
-	max_align_t   data[1];  /* not allocated, see below */
+	h_max_align_t   data[1];  /* not allocated, see below */

 } hblock_t;
