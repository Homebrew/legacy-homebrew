require 'formula'

class Zeromq < Formula
  homepage 'http://www.zeromq.org/'
  url 'http://download.zeromq.org/zeromq-3.2.3.tar.gz'
  sha1 '6857a3a0e908eca58f7c0f90e2ba4695f6700957'

  head 'https://github.com/zeromq/libzmq.git'

  option :universal
  option 'with-pgm', 'Build with PGM extension'

  depends_on 'pkg-config' => :build
  depends_on 'libpgm' if build.include? 'with-pgm'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  fails_with :llvm do
    build 2326
    cause "Segfault while linking"
  end

  # Address lack of strndup on 10.6, fixed upstream
  # https://github.com/zeromq/zeromq3-x/commit/400cbc208a768c4df5039f401dd2688eede6e1ca
  def patches; DATA; end unless build.head?

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    if build.include? 'with-pgm'
      # Use HB libpgm-5.2 because their internal 5.1 is b0rked.
      ENV['OpenPGM_CFLAGS'] = %x[pkg-config --cflags openpgm-5.2].chomp
      ENV['OpenPGM_LIBS'] = %x[pkg-config --libs openpgm-5.2].chomp
      args << "--with-system-pgm"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    To install the zmq gem on 10.6 with the system Ruby on a 64-bit machine,
    you may need to do:

        ARCHFLAGS="-arch x86_64" gem install zmq -- --with-zmq-dir=#{opt_prefix}
    EOS
  end
end

__END__
diff --git a/tests/test_disconnect_inproc.cpp b/tests/test_disconnect_inproc.cpp
index 7875083..d6b68c6 100644
--- a/tests/test_disconnect_inproc.cpp
+++ b/tests/test_disconnect_inproc.cpp
@@ -40,16 +40,14 @@ int main(int argc, char** argv) {
                 zmq_msg_t msg;
                 zmq_msg_init (&msg);
                 zmq_msg_recv (&msg, pubSocket, 0);
-                int msgSize = zmq_msg_size(&msg);
                 char* buffer = (char*)zmq_msg_data(&msg);
 
                 if (buffer[0] == 0) {
                     assert(isSubscribed);
-                    printf("unsubscribing from '%s'\n", strndup(buffer + 1, msgSize - 1));
                     isSubscribed = false;
-                } else {
+                } 
+                else {
                     assert(!isSubscribed);
-                    printf("subscribing on '%s'\n", strndup(buffer + 1, msgSize - 1));
                     isSubscribed = true;
                 }
 
@@ -66,11 +64,6 @@ int main(int argc, char** argv) {
                 zmq_msg_t msg;
                 zmq_msg_init (&msg);
                 zmq_msg_recv (&msg, subSocket, 0);
-                int msgSize = zmq_msg_size(&msg);
-                char* buffer = (char*)zmq_msg_data(&msg);
-        
-                printf("received on subscriber '%s'\n", strndup(buffer, msgSize));
-        
                 zmq_getsockopt (subSocket, ZMQ_RCVMORE, &more, &more_size);
                 zmq_msg_close (&msg);
         

