require 'formula'
require 'hardware'

class Go < Formula
  if ARGV.include? "--use-git"
    url 'https://github.com/tav/go.git', :tag => 'release.r58.1'
    head 'https://github.com/tav/go.git'
  else
    url 'http://go.googlecode.com/hg/', :revision => 'release.r58.1'
    head 'http://go.googlecode.com/hg/'
  end
  version 'r58.1'
  homepage 'http://golang.org'

  skip_clean 'bin'

  def options
    [["--use-git", "Use git mirror instead of official hg repository"]]
  end

  def install
    ENV.j1 # Building in parallel fails
    prefix.install %w[src include test doc misc lib favicon.ico AUTHORS]
    Dir.chdir prefix
    mkdir %w[pkg bin]

    Dir.chdir 'src' do
      # Some tests fail on Lion, so do this instead of "./all.bash"
      system "./make.bash"
    end

    # Don't need the src folder, but do keep the Makefiles as Go projects use these
    Dir['src/*'].each{|f| rm_rf f unless f.match(/^src\/(pkg|Make)/) }
    rm_rf %w[include test]
  end
end

__END__
diff --git a/src/pkg/deps.bash b/src/pkg/deps.bash
index a8e3dfc..2095ec1 100755
--- a/src/pkg/deps.bash
+++ b/src/pkg/deps.bash
@@ -15,7 +15,13 @@ fi
 
 # Get list of directories from Makefile
 dirs=$(gomake --no-print-directory echo-dirs)
-dirpat=$(echo $dirs C | sed 's/ /|/g; s/.*/^(&)$/')
+dirpat=$(echo $dirs C | awk '{
+	for(i=1;i<=NF;i++){ 
+		x=$i
+		gsub("/", "\\/", x)
+		printf("/^(%s)$/\n", x)
+	}
+}')
 
 for dir in $dirs; do (
 	cd $dir || exit 1
@@ -30,7 +36,7 @@ for dir in $dirs; do (
 	deps=$(
 		sed -n '/^import.*"/p; /^import[ \t]*(/,/^)/p' $sources /dev/null |
 		cut -d '"' -f2 |
-		egrep "$dirpat" |
+		awk "$dirpat" |
 		grep -v "^$dir\$" |
 		sed 's/$/.install/' |
 		sed 's;^C\.install;runtime/cgo.install;' |
