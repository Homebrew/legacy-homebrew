require "formula"

class Gpshell < Formula
  homepage "http://sourceforge.net/p/globalplatform/wiki/Home/"
  url "https://downloads.sourceforge.net/project/globalplatform/GPShell/GPShell-1.4.4/gpshell-1.4.4.tar.gz"
  sha1 "3efeb92263e881ff0886e73a7b790051a317df61"

  depends_on 'globalplatform'
  depends_on 'gppcscconnectionplugin'

  # ./configure doesn't recognize GlobalPlatform without this
  depends_on 'pkg-config' => :build

  def install
    ENV.append 'PCSCLITE_CFLAGS', "-I#{MacOS.sdk_path}/System/Library/Frameworks/PCSC.framework/Versions/A/Headers/"
    ENV.append 'GLOBALPLATFORM_CFLAGS', "-I#{Formula["globalplatform"].opt_prefix}/include/globalplatform"
    ENV.append 'GLOBALPLATFORM_LIBS', "#{Formula["globalplatform"].opt_prefix}/lib/libglobalplatform.dylib"


    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  # FIXME: I can't figure out any way to boot up `pcscd` without superuser access. It insists on trying
  #        to write to `/var/run`, and there's nothing I can do about that. This may be something
  #        Homebrew needs to be patched to support. (Perhaps offering `chroot` functionality for tests?)
# test do
#   # pcscd *should* be provided by the system; but the implementation on OS X seems wonky. Even when
#   # operating *properly*, it doesn't boot up until an actual smart-card reader is inserted. Or sommat.
#   pid = fork do
#     exec '/usr/sbin/pcscd', '-adf'
#   end
#   sleep 5 # Allow pcscd to boot
#
#   # Because we don't have any actual reader for the test, I simply test that GPShell executes
#   # scriptfiles and connects to pcscd.
#   gptest = <<-EOS.undent
#     mode_211
#     enable_trace
#     establish_context
#     release_context
#   EOS
#
#   (testpath/'gptest.txt').write gptest
#   assert_equal gptest, `#{bin/'gpshell'} gptest.txt`
#
#   # Shut down pcscd
#   Process.kill 'TERM', pid
#   Process.wait pid
# end
end
