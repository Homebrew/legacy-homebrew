class Mongrel2 < Formula
  desc "Application, language, and network architecture agnostic web server"
  homepage "http://mongrel2.org/"
  url "https://github.com/mongrel2/mongrel2/releases/download/v1.9.3/mongrel2-v1.9.3.tar.bz2"
  sha256 "40ee0e804053f812cc36906464289ea656a4fc53b4a82d49796cafbe37f97425"

  head "https://github.com/mongrel2/mongrel2.git", :branch => "develop"

  bottle do
    cellar :any
    revision 1
    sha256 "90e7c30a269edc9ac6308b3dadb24565a4cd12a73b8b5f1a6e7c700b67c94cfa" => :el_capitan
    sha256 "d8e720c2b15edef337a4b064d5525bd9d82b55e8dccb9cd69152c9b4d3505517" => :yosemite
    sha256 "0412a19e55674114c6e2efb09d09cf8998a21b2aad03bfeed67bf9e7a946b694" => :mavericks
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
