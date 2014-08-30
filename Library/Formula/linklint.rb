require 'formula'

class Linklint < Formula
  homepage 'http://linklint.org'
  url 'http://linklint.org/download/linklint-2.3.5.tar.gz'
  sha1 'd2dd384054b39a09c17b69e617f7393e44e98376'

  devel do
    url 'http://linklint.org/download/linklint-2.4.beta.tar.gz'
    sha1 'a159d19b700db52e8a9e2d89a0a8984eb627bf17'

    # original author did not update the version reported with the beta
    patch :DATA
  end

  def install
    mv 'READ_ME.txt', 'README' unless build.devel?
    (share+'doc/linklint').install "README"
    bin.install "linklint-#{version}" => "linklint"
  end

  test do
    system "#{bin}/linklint" "-http" "-host" "brew.sh" "/"
  end
end

__END__
diff --git a/linklint-2.4.beta b/linklint-2.4.beta
index cf3f9a8..0f30eee 100755
--- a/linklint-2.4.beta
+++ b/linklint-2.4.beta
@@ -54,7 +54,7 @@
 # 
 #========================================================================
 
-$version = "2.3.1";
+$version = "2.4.beta";
 $date    = "June 21, 2001";
 $prog    = "linklint";
 
