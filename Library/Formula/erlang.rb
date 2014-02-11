require 'formula'

# Major releases of erlang should typically start out as separate formula in
# Homebrew-versions, and only be merged to master when things like couchdb and
# elixir are compatible.
class Erlang < Formula
  homepage 'http://www.erlang.org'
  url 'http://www.erlang.org/download/otp_src_R16B03-1.tar.gz'
  sha1 'c2634ea0c078500f1c6a1369f4be59a6d14673e0'

  head 'https://github.com/erlang/otp.git', :branch => 'master'

  resource 'man' do
    url 'http://erlang.org/download/otp_doc_man_R16B03-1.tar.gz'
    sha1 'afde5507a389734adadcd4807595f8bc76ebde1b'
  end

  resource 'html' do
    url 'http://erlang.org/download/otp_doc_html_R16B03-1.tar.gz'
    sha1 'a2c0d2b7b9abe6214aff4c75ecc6be62042924e6'
  end

  option 'disable-hipe', "Disable building hipe; fails on various OS X systems"
  option 'halfword', 'Enable halfword emulator (64-bit builds only)'
  option 'time', '`brew test --time` to include a time-consuming test'
  option 'no-docs', 'Do not install documentation'

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end
  depends_on 'unixodbc' if MacOS.version >= :mavericks
  depends_on 'fop' => :optional # enables building PDF docs
  depends_on 'wxmac' => ['disable-monolithic', :recommended]

  fails_with :llvm

  def patches
    # Fixes problem with ODBC on Mavericks. Fixed upstream/HEAD:
    # https://github.com/erlang/otp/pull/142
    DATA if MacOS.version >= :mavericks && !build.head?
  end

  def install
    ohai "Compilation takes a long time; use `brew install -v erlang` to see progress" unless ARGV.verbose?

    ENV.append "FOP", "#{HOMEBREW_PREFIX}/bin/fop" if build.with? 'fop'

    # Do this if building from a checkout to generate configure
    system "./otp_build autoconf" if build.head?

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-kernel-poll
      --enable-threads
      --enable-dynamic-ssl-lib
      --enable-shared-zlib
      --enable-smp-support
    ]

    args << "--enable-wx" if build.with? 'wxmac'
    args << "--with-dynamic-trace=dtrace" unless MacOS.version <= :leopard or not MacOS::CLT.installed?

    unless build.include? 'disable-hipe'
      # HIPE doesn't strike me as that reliable on OS X
      # http://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # http://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      args << '--enable-hipe'
    end

    if MacOS.prefer_64_bit?
      args << "--enable-darwin-64bit"
      args << "--enable-halfword-emulator" if build.include? 'halfword' # Does not work with HIPE yet. Added for testing only
    end

    system "./configure", *args
    system "make"
    ENV.j1 # Install is not thread-safe; can try to create folder twice and fail
    system "make install"

    unless build.include? 'no-docs'
      (lib/'erlang').install resource('man').files('man')
      doc.install resource('html')
    end
  end

  def caveats; <<-EOS.undent
    Man pages can be found in:
      #{opt_prefix}/lib/erlang/man

    Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  def test
    `#{bin}/erl -noshell -eval 'crypto:start().' -s init stop`

    # This test takes some time to run, but per bug #120 should finish in
    # "less than 20 minutes". It takes about 20 seconds on a Mac Pro (2009).
    if build.include?("time") && !build.head?
      `#{bin}/dialyzer --build_plt -r #{lib}/erlang/lib/kernel-2.16.3/ebin/`
    end
  end
end
__END__
diff --git a/lib/odbc/configure.in b/lib/odbc/configure.in
index 83f7a47..fd711fe 100644
--- a/lib/odbc/configure.in
+++ b/lib/odbc/configure.in
@@ -130,7 +130,7 @@ AC_SUBST(THR_LIBS)
 odbc_lib_link_success=no
 AC_SUBST(TARGET_FLAGS)
     case $host_os in
-        darwin*)
+        darwin1[[0-2]].*|darwin[[0-9]].*)
                 TARGET_FLAGS="-DUNIX"
                if test ! -d "$with_odbc" || test "$with_odbc" = "yes"; then
                    ODBC_LIB= -L"/usr/lib"
