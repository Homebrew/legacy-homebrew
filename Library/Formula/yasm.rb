require 'formula'

class Yasm < Formula
  homepage 'http://yasm.tortall.net/'
  url 'http://tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz'
  sha256 '768ffab457b90a20a6d895c39749adb547c1b7cb5c108e84b151a838a23ccf31'
  revision 1

  bottle do
    cellar :any
    sha1 "cd4b87a7ab1a80b4461b6b21f4a51e98186a225e" => :mavericks
    sha1 "adf3e0d26dbb17a37c310d7bdf8821d54a4f5914" => :mountain_lion
    sha1 "b5f60c20bd5e5b475d982f994f3754f07e63674f" => :lion
  end

  head do
    url 'https://github.com/yasm/yasm.git'

    depends_on 'gettext'
    depends_on :autoconf
    depends_on :automake
  end

  depends_on :python => :optional
  depends_on 'Cython' => :python if build.with? 'python'

  # Yasm segfaults on some GNU assembler files on OS X
  # http://tortall.lighthouseapp.com/projects/78676/tickets/269
  patch :DATA

  def install
    # https://github.com/Homebrew/homebrew/pull/19593
    ENV.deparallelize
    args = %W[
      --disable-debug
      --prefix=#{prefix}
    ]

    if build.with? 'python'
      args << '--enable-python'
      args << '--enable-python-bindings'
    end

    system './autogen.sh' if build.head?
    system './configure', *args
    system 'make install'
  end
end

__END__
index 96dec82..0ca18d0 100644
--- a/modules/preprocs/gas/gas-preproc.c
+++ b/modules/preprocs/gas/gas-preproc.c
@@ -409,12 +409,14 @@ static int gas_scan(void *preproc, struct tokenval *tokval)
             { "^^", TOKEN_DBL_XOR },
             { "||", TOKEN_DBL_OR }
         };
-        for (i = 0; i < sizeof(ops)/sizeof(ops[0]); i++) {
-            if (!strcmp(str, ops[i].op)) {
-                tokval->t_type = ops[i].token;
-                break;
+       if (strlen(str) > 1) {
+            for (i = 0; i < sizeof(ops)/sizeof(ops[0]); i++) {
+                if (!strncmp(str, ops[i].op, 2)) {
+                    tokval->t_type = ops[i].token;
+                    break;
+                }
             }
-        }
+       }
     }

     if (tokval->t_type != TOKEN_INVALID) {
@@ -427,7 +429,7 @@ static int gas_scan(void *preproc, struct tokenval *tokval)
         tokval->t_type = c;

         /* Is it a symbol? If so we need to make it a TOKEN_ID. */
-        if (isalpha(c) || c == '_' || c == '.') {
+        if (isalpha(c) || c == '_' || c == '.' || c == '%') {
             int symbol_length = 1;

             c = get_char(pp);
@@ -829,7 +831,7 @@ static int eval_macro(yasm_preproc_gas *pp, int unused, char *args)
         skip_whitespace2(&line2);
         if (starts_with(line2, ".macro")) {
             nesting++;
-        } else if (starts_with(line, ".endm") && --nesting == 0) {
+        } else if (starts_with(line2, ".endm") && --nesting == 0) {
             return 1;
         }
         macro->num_lines++;
