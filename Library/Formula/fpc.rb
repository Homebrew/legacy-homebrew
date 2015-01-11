class Fpc < Formula
  homepage "http://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/2.6.4/fpc-2.6.4.source.tar.gz"
  sha1 "60eeadf65db25b10b174627457a5799bf0fd0d52"

  bottle do
    cellar :any
    sha1 "c77e7a5b6b9fb84b9d90bb4515a8557ccb98a253" => :mavericks
    sha1 "47f760e84fc84f845718efe4737402e086de705c" => :mountain_lion
    sha1 "90d3b9d4ad5e3d06efc0108e0b1dbd8e58b18034" => :lion
  end

  resource "bootstrap" do
    url "https://downloads.sourceforge.net/project/freepascal/Bootstrap/2.6.4/universal-macosx-10.5-ppcuniversal.tar.bz2"
    sha1 "1476a19ad7f901868fcbe3dc49e6d46a5865f722"
  end

  if MacOS.version >= :yosemite
    # Use updated crt1 linking logic from upstream
    patch do
      url "https://github.com/graemeg/freepascal/commit/74a5a86cc7f1f978404f9dc172655658ce18c2d1.diff"
      sha1 "97fdcee78faf11bca12fc654eb399f92941d3910"
    end
    # Manually set minimum OS X version for bootstrapping (note '1099' due to length limit)
    patch :DATA
  end

  def install
    fpc_bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage { fpc_bootstrap.install Dir["*"] }

    if MacOS.version >= :yosemite
      # Provde a missing symlink for bootstrapping
      fpc_bootstrap.install_symlink "#{MacOS.sdk_path}/usr/lib/crt1.10.5.o"
    end

    fpc_compiler = fpc_bootstrap/"ppcuniversal"
    system "make", "build", "PP=#{fpc_compiler}"
    system "make", "install", "PP=#{fpc_compiler}", "PREFIX=#{prefix}"

    bin.install_symlink lib/"#{name}/#{version}/ppcx64"
  end

  test do
    hello = <<-EOS.undent
      program Hello;
      begin
        writeln('Hello Homebrew')
      end.
    EOS
    (testpath/"hello.pas").write(hello)
    system "#{bin}/fpc", "hello.pas"
    assert_equal "Hello Homebrew", `./hello`.strip
  end
end

__END__
diff --git a/compiler/options.pas b/compiler/options.pas
index b488f36..40ff9bc 100644
--- a/compiler/options.pas
+++ b/compiler/options.pas
@@ -530,7 +530,7 @@ function toption.ParseMacVersionMin(out minstr, emptystr: string; const compvarn
     if not ios then
       begin
         if length(temp)<>1 then
-          exit(false);
+          begin end;
       end
     { the minor version number always takes up two digits on iOS }
     else if length(temp)=1 then
@@ -566,7 +566,10 @@ function toption.ParseMacVersionMin(out minstr, emptystr: string; const compvarn
           exit(false);
       end
     else if not ios then
-      compvarvalue:=compvarvalue+'0'
+      if length(temp)<>1 then
+        compvarvalue:=copy(compvarvalue,0,2)+'99'
+      else
+        compvarvalue:=compvarvalue+'0'
     else
       compvarvalue:=compvarvalue+'00';
     set_system_compvar(compvarname,compvarvalue);
@@ -619,8 +622,8 @@ begin
       begin
         { actually already works on 10.4, but it's unlikely any 10.4 system
           with an x86-64 is still in use, so don't default to it }
-        set_system_compvar('MAC_OS_X_VERSION_MIN_REQUIRED','1050');
-        MacOSXVersionMin:='10.5';
+        set_system_compvar('MAC_OS_X_VERSION_MIN_REQUIRED','1099');
+        MacOSXVersionMin:='10.10';
       end;
     system_arm_darwin,
     system_i386_iphonesim:
