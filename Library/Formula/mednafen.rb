require 'formula'

class Mednafen < Formula
  homepage 'http://mednafen.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/mednafen/Mednafen/0.8.D.3/mednafen-0.8.D.3.tar.bz2'
  md5 '57d22805071becd81858b0c088a275e5'
  version '0.8.D.3'

  devel do
    url 'http://forum.fobby.net/index.php?t=getfile&id=345'
    md5 '64be12196aa02828539af677b0e2a66c'
    version '0.9.19-WIP'
  end

  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'sdl_net'
  depends_on 'libcdio'
  depends_on 'libsndfile'

  def options
    [
      ["--with-psx", "Build experimental PlayStation emulator"]
    ]
  end

  def patches
    # see http://forum.fobby.net/index.php?t=msg&&th=701&goto=2420#msg_2420
    # will probably be fixed in the next version
    DATA if ARGV.build_devel?
  end

  def install
    # Compiler produces code which fails math tests
    # with optimizations enabled
    # http://forum.fobby.net/index.php?t=msg&&th=659&goto=2254#msg_2254
    ENV.no_optimization

    args = [ "--disable-dependency-tracking", "--prefix=#{prefix}" ]

    if ARGV.include? "--with-psx" and not ARGV.build_devel?
      onoe "--with-psx is only supported with --devel" \
    end
    args << "--enable-psx" if ARGV.include? "--with-psx" and ARGV.build_devel?

    # Platform detection is buggy; problem reported upstream:
    # http://forum.fobby.net/index.php?t=msg&&th=659&goto=2214#msg_2214
    args << "--build=x86_64-apple-darwin#{`uname -r`}" if MacOS.prefer_64_bit?

    system "./configure", *args
    system "make install"
  end
end

__END__
diff -Naur mednafen.orig/mednafen/drivers/shader.cpp mednafen.wip/mednafen/drivers/shader.cpp
--- mednafen.orig/mednafen/drivers/shader.cpp	2012-01-26 04:04:57.000000000 +0100
+++ mednafen.wip/mednafen/drivers/shader.cpp	2012-02-08 10:34:38.000000000 +0100
@@ -70,7 +70,7 @@
  switch(ipolate_axis & 3)
  {
   case 0:
-	ret += std::string("gl_FragColor = texture2D(Tex0, gl_TexCoord[0]);\n");
+	ret += std::string("gl_FragColor = texture2D(Tex0, vec2(gl_TexCoord[0]));\n");
 	break;
 
   case 1:
