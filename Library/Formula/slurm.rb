require "formula"

class Slurm < Formula
  homepage "https://github.com/mattthias/slurm"
  url "https://github.com/mattthias/slurm/archive/upstream/0.4.0.tar.gz"
  sha1 "b50c2245513f1241f78a487504eb5e460aec9a04"

  bottle do
    cellar :any
    sha1 "337859641874b00b07d68193b478b3d24f662f18" => :mavericks
    sha1 "d46703938055e25cf259cb571b89af042328c96c" => :mountain_lion
    sha1 "be55409fce424e606344f9d904423a7f09cd4caa" => :lion
  end

  depends_on "scons" => :build

  # patch to support colour ncurses on OS X
  # see https://github.com/mattthias/slurm/pull/2
  patch :DATA

  def install
    scons
    bin.install "slurm"
  end

  test do
    system "#{bin}/slurm", "-h"
  end
end

__END__
diff --git a/SConstruct b/SConstruct
index 8c85b77..de3d82b 100644
--- a/SConstruct
+++ b/SConstruct
@@ -5,6 +5,8 @@ if os.uname()[0] == 'Linux':
	env.Append(CPPDEFINES=['_HAVE_NCURSES','_HAVE_NCURSES_COLOR'])
 elif os.uname()[0] == 'GNU/kFreeBSD':
	env.Append(CPPDEFINES=['_HAVE_NCURSES','_HAVE_NCURSES_COLOR'])
+elif os.uname()[0] == 'Darwin':
+	env.Append(CPPDEFINES=['_HAVE_NCURSES','_HAVE_NCURSES_COLOR'])

 env.Append( LIBS = ['ncurses'] )
