require 'formula'

class Bash < Formula
  homepage 'http://www.gnu.org/software/bash/'
  url 'http://ftpmirror.gnu.org/bash/bash-4.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/bash/bash-4.2.tar.gz'
  sha256 'a27a1179ec9c0830c65c6aa5d7dab60f7ce1a2a608618570f96bfa72e95ab3d8'
  version '4.2.37'

  depends_on 'readline'

  # Vendor the patches.
  # The mirrors are unreliable for getting the patches, and the more patches
  # there are, the more unreliable they get. Pulling these patches inline.
  # Upstream patches can be found in:
  # http://ftpmirror.gnu.org/bash/bash-4.2-patches
  def patches; DATA; end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-installed-readline"
    system "make install"
  end

  def caveats; <<-EOS.undent
    In order to use this build of bash as your login shell,
    it must be added to /etc/shells.
    EOS
  end
end

__END__
diff --git a/assoc.c b/assoc.c
index bbc7b17..4561de4 100644
--- a/assoc.c
+++ b/assoc.c
@@ -77,6 +77,11 @@ assoc_insert (hash, key, value)
   b = hash_search (key, hash, HASH_CREATE);
   if (b == 0)
     return -1;
+  /* If we are overwriting an existing element's value, we're not going to
+     use the key.  Nothing in the array assignment code path frees the key
+     string, so we can free it here to avoid a memory leak. */
+  if (b->key != key)
+    free (key);
   FREE (b->data);
   b->data = value ? savestring (value) : (char *)0;
   return (0);
diff --git a/bashline.c b/bashline.c
index 52c6de6..3cbb18f 100644
--- a/bashline.c
+++ b/bashline.c
@@ -121,6 +121,9 @@ static int bash_directory_completion_hook __P((char **));
 static int filename_completion_ignore __P((char **));
 static int bash_push_line __P((void));
 
+static rl_icppfunc_t *save_directory_hook __P((void));
+static void reset_directory_hook __P((rl_icppfunc_t *));
+
 static void cleanup_expansion_error __P((void));
 static void maybe_make_readline_line __P((char *));
 static void set_up_new_line __P((char *));
@@ -243,10 +246,17 @@ int force_fignore = 1;
 /* Perform spelling correction on directory names during word completion */
 int dircomplete_spelling = 0;
 
+/* Expand directory names during word/filename completion. */
+int dircomplete_expand = 0;
+int dircomplete_expand_relpath = 0;
+
 static char *bash_completer_word_break_characters = " \t\n\"'@><=;|&(:";
 static char *bash_nohostname_word_break_characters = " \t\n\"'><=;|&(:";
 /* )) */
 
+static const char *default_filename_quote_characters = " \t\n\\\"'@<>=;|&()#$`?*[!:{~";	/*}*/
+static char *custom_filename_quote_characters = 0;
+
 static rl_hook_func_t *old_rl_startup_hook = (rl_hook_func_t *)NULL;
 
 static int dot_in_path = 0;
@@ -501,7 +511,7 @@ initialize_readline ()
 
   /* Tell the completer that we might want to follow symbolic links or
      do other expansion on directory names. */
-  rl_directory_rewrite_hook = bash_directory_completion_hook;
+  set_directory_hook ();
 
   rl_filename_rewrite_hook = bash_filename_rewrite_hook;
 
@@ -529,7 +539,7 @@ initialize_readline ()
   enable_hostname_completion (perform_hostname_completion);
 
   /* characters that need to be quoted when appearing in filenames. */
-  rl_filename_quote_characters = " \t\n\\\"'@<>=;|&()#$`?*[!:{~";	/*}*/
+  rl_filename_quote_characters = default_filename_quote_characters;
 
   rl_filename_quoting_function = bash_quote_filename;
   rl_filename_dequoting_function = bash_dequote_filename;
@@ -564,8 +574,10 @@ bashline_reset ()
   tilde_initialize ();
   rl_attempted_completion_function = attempt_shell_completion;
   rl_completion_entry_function = NULL;
-  rl_directory_rewrite_hook = bash_directory_completion_hook;
   rl_ignore_some_completions_function = filename_completion_ignore;
+  rl_filename_quote_characters = default_filename_quote_characters;
+
+  set_directory_hook ();
 }
 
 /* Contains the line to push into readline. */
@@ -1279,6 +1291,9 @@ attempt_shell_completion (text, start, end)
   matches = (char **)NULL;
   rl_ignore_some_completions_function = filename_completion_ignore;
 
+  rl_filename_quote_characters = default_filename_quote_characters;
+  set_directory_hook ();
+
   /* Determine if this could be a command word.  It is if it appears at
      the start of the line (ignoring preceding whitespace), or if it
      appears after a character that separates commands.  It cannot be a
@@ -1591,6 +1606,12 @@ command_word_completion_function (hint_text, state)
 	    }
 	  else
 	    {
+	     if (dircomplete_expand && dot_or_dotdot (filename_hint))
+		{
+		  dircomplete_expand = 0;
+		  set_directory_hook ();
+		  dircomplete_expand = 1;
+		}
 	      mapping_over = 4;
 	      goto inner;
 	    }
@@ -1791,6 +1812,9 @@ globword:
 
  inner:
   val = rl_filename_completion_function (filename_hint, istate);
+  if (mapping_over == 4 && dircomplete_expand)
+    set_directory_hook ();
+
   istate = 1;
 
   if (val == 0)
@@ -2693,6 +2717,52 @@ bash_filename_rewrite_hook (fname, fnlen)
   return conv;
 }
 
+/* Functions to save and restore the appropriate directory hook */
+/* This is not static so the shopt code can call it */
+void
+set_directory_hook ()
+{
+  if (dircomplete_expand)
+    {
+      rl_directory_completion_hook = bash_directory_completion_hook;
+      rl_directory_rewrite_hook = (rl_icppfunc_t *)0;
+    }
+  else
+    {
+      rl_directory_rewrite_hook = bash_directory_completion_hook;
+      rl_directory_completion_hook = (rl_icppfunc_t *)0;
+    }
+}
+
+static rl_icppfunc_t *
+save_directory_hook ()
+{
+  rl_icppfunc_t *ret;
+
+  if (dircomplete_expand)
+    {
+      ret = rl_directory_completion_hook;
+      rl_directory_completion_hook = (rl_icppfunc_t *)NULL;
+    }
+  else
+    {
+      ret = rl_directory_rewrite_hook;
+      rl_directory_rewrite_hook = (rl_icppfunc_t *)NULL;
+    }
+
+  return ret;
+}
+
+static void
+restore_directory_hook (hookf)
+     rl_icppfunc_t *hookf;
+{
+  if (dircomplete_expand)
+    rl_directory_completion_hook = hookf;
+  else
+    rl_directory_rewrite_hook = hookf;
+}
+
 /* Handle symbolic link references and other directory name
    expansions while hacking completion.  This should return 1 if it modifies
    the DIRNAME argument, 0 otherwise.  It should make sure not to modify
@@ -2702,20 +2772,31 @@ bash_directory_completion_hook (dirname)
      char **dirname;
 {
   char *local_dirname, *new_dirname, *t;
-  int return_value, should_expand_dirname;
+  int return_value, should_expand_dirname, nextch, closer;
   WORD_LIST *wl;
   struct stat sb;
 
-  return_value = should_expand_dirname = 0;
+  return_value = should_expand_dirname = nextch = closer = 0;
   local_dirname = *dirname;
 
-  if (mbschr (local_dirname, '$'))
-    should_expand_dirname = 1;
+  if (t = mbschr (local_dirname, '$'))
+    {
+      should_expand_dirname = '$';
+      nextch = t[1];
+      /* Deliberately does not handle the deprecated $[...] arithmetic
+	 expansion syntax */
+      if (nextch == '(')
+	closer = ')';
+      else if (nextch == '{')
+	closer = '}';
+      else
+	nextch = 0;
+    }
   else
     {
       t = mbschr (local_dirname, '`');
       if (t && unclosed_pair (local_dirname, strlen (local_dirname), "`") == 0)
-	should_expand_dirname = 1;
+	should_expand_dirname = '`';
     }
 
 #if defined (HAVE_LSTAT)
@@ -2739,6 +2820,23 @@ bash_directory_completion_hook (dirname)
 	  free (new_dirname);
 	  dispose_words (wl);
 	  local_dirname = *dirname;
+	  /* XXX - change rl_filename_quote_characters here based on
+	     should_expand_dirname/nextch/closer.  This is the only place
+	     custom_filename_quote_characters is modified. */
+	  if (rl_filename_quote_characters && *rl_filename_quote_characters)
+	    {
+	      int i, j, c;
+	      i = strlen (default_filename_quote_characters);
+	      custom_filename_quote_characters = xrealloc (custom_filename_quote_characters, i+1);
+	      for (i = j = 0; c = default_filename_quote_characters[i]; i++)
+		{
+		  if (c == should_expand_dirname || c == nextch || c == closer)
+		    continue;
+		  custom_filename_quote_characters[j++] = c;
+		}
+	      custom_filename_quote_characters[j] = '\0';
+	      rl_filename_quote_characters = custom_filename_quote_characters;
+	    }
 	}
       else
 	{
@@ -2758,11 +2856,31 @@ bash_directory_completion_hook (dirname)
       local_dirname = *dirname = new_dirname;
     }
 
+  /* no_symbolic_links == 0 -> use (default) logical view of the file system.
+     local_dirname[0] == '.' && local_dirname[1] == '/' means files in the
+     current directory (./).
+     local_dirname[0] == '.' && local_dirname[1] == 0 means relative pathnames
+     in the current directory (e.g., lib/sh).
+     XXX - should we do spelling correction on these? */
+
+  /* This is test as it was in bash-4.2: skip relative pathnames in current
+     directory.  Change test to
+      (local_dirname[0] != '.' || (local_dirname[1] && local_dirname[1] != '/'))
+     if we want to skip paths beginning with ./ also. */
   if (no_symbolic_links == 0 && (local_dirname[0] != '.' || local_dirname[1]))
     {
       char *temp1, *temp2;
       int len1, len2;
 
+      /* If we have a relative path
+      		(local_dirname[0] != '/' && local_dirname[0] != '.')
+	 that is canonical after appending it to the current directory, then
+	 	temp1 = temp2+'/'
+	 That is,
+	 	strcmp (temp1, temp2) == 0
+	 after adding a slash to temp2 below.  It should be safe to not
+	 change those.
+      */
       t = get_working_directory ("symlink-hook");
       temp1 = make_absolute (local_dirname, t);
       free (t);
@@ -2797,7 +2915,15 @@ bash_directory_completion_hook (dirname)
 	      temp2[len2 + 1] = '\0';
 	    }
 	}
-      return_value |= STREQ (local_dirname, temp2) == 0;
+
+      /* dircomplete_expand_relpath == 0 means we want to leave relative
+	 pathnames that are unchanged by canonicalization alone.
+	 *local_dirname != '/' && *local_dirname != '.' == relative pathname
+	 (consistent with general.c:absolute_pathname())
+	 temp1 == temp2 (after appending a slash to temp2) means the pathname
+	 is not changed by canonicalization as described above. */
+      if (dircomplete_expand_relpath || ((local_dirname[0] != '/' && local_dirname[0] != '.') && STREQ (temp1, temp2) == 0))
+	return_value |= STREQ (local_dirname, temp2) == 0;
       free (local_dirname);
       *dirname = temp2;
       free (temp1);
@@ -3002,12 +3128,13 @@ bash_complete_filename_internal (what_to_do)
 
   orig_func = rl_completion_entry_function;
   orig_attempt_func = rl_attempted_completion_function;
-  orig_dir_func = rl_directory_rewrite_hook;
   orig_ignore_func = rl_ignore_some_completions_function;
   orig_rl_completer_word_break_characters = rl_completer_word_break_characters;
+
+  orig_dir_func = save_directory_hook ();
+
   rl_completion_entry_function = rl_filename_completion_function;
   rl_attempted_completion_function = (rl_completion_func_t *)NULL;
-  rl_directory_rewrite_hook = (rl_icppfunc_t *)NULL;
   rl_ignore_some_completions_function = filename_completion_ignore;
   rl_completer_word_break_characters = " \t\n\"\'";
 
@@ -3015,10 +3142,11 @@ bash_complete_filename_internal (what_to_do)
 
   rl_completion_entry_function = orig_func;
   rl_attempted_completion_function = orig_attempt_func;
-  rl_directory_rewrite_hook = orig_dir_func;
   rl_ignore_some_completions_function = orig_ignore_func;
   rl_completer_word_break_characters = orig_rl_completer_word_break_characters;
 
+  restore_directory_hook (orig_dir_func);
+
   return r;
 }
 
diff --git a/bashline.h b/bashline.h
index 9daa8f9..38964ea 100644
--- a/bashline.h
+++ b/bashline.h
@@ -33,10 +33,15 @@ extern void bashline_reset __P((void));
 extern void bashline_reinitialize __P((void));
 extern int bash_re_edit __P((char *));
 
+extern void bashline_set_event_hook __P((void));
+extern void bashline_reset_event_hook __P((void));
+
 extern int bind_keyseq_to_unix_command __P((char *));
 
 extern char **bash_default_completion __P((const char *, int, int, int, int));
 
+void set_directory_hook __P((void));
+
 /* Used by programmable completion code. */
 extern char *command_word_completion_function __P((const char *, int));
 extern char *bash_groupname_completion_function __P((const char *, int));
diff --git a/builtins/declare.def b/builtins/declare.def
index 55206fa..8b9b850 100644
--- a/builtins/declare.def
+++ b/builtins/declare.def
@@ -513,6 +513,11 @@ declare_internal (list, local_var)
 	      *subscript_start = '[';	/* ] */
 	      var = assign_array_element (name, value, 0);	/* XXX - not aflags */
 	      *subscript_start = '\0';
+	      if (var == 0)	/* some kind of assignment error */
+		{
+		  assign_error++;
+		  NEXT_VARIABLE ();
+		}
 	    }
 	  else if (simple_array_assign)
 	    {
diff --git a/builtins/fc.def b/builtins/fc.def
index 257029d..9b298cb 100644
--- a/builtins/fc.def
+++ b/builtins/fc.def
@@ -304,7 +304,7 @@ fc_builtin (list)
   last_hist = i - rh - hist_last_line_added;
 
   /* XXX */
-  if (saved_command_line_count > 0 && i == last_hist && hlist[last_hist] == 0)
+  if (i == last_hist && hlist[last_hist] == 0)
     while (last_hist >= 0 && hlist[last_hist] == 0)
       last_hist--;
   if (last_hist < 0)
@@ -475,7 +475,7 @@ fc_gethnum (command, hlist)
      HIST_ENTRY **hlist;
 {
   int sign, n, clen, rh;
-  register int i, j;
+  register int i, j, last_hist;
   register char *s;
 
   sign = 1;
@@ -495,7 +495,15 @@ fc_gethnum (command, hlist)
      has been enabled (interactive or not) should use it in the last_hist
      calculation as if it were on. */
   rh = remember_on_history || ((subshell_environment & SUBSHELL_COMSUB) && enable_history_list);
-  i -= rh + hist_last_line_added;
+  last_hist = i - rh - hist_last_line_added;
+
+  if (i == last_hist && hlist[last_hist] == 0)
+    while (last_hist >= 0 && hlist[last_hist] == 0)
+      last_hist--;
+  if (last_hist < 0)
+    return (-1);
+
+  i = last_hist;
 
   /* No specification defaults to most recent command. */
   if (command == NULL)
diff --git a/builtins/mapfile.def b/builtins/mapfile.def
index ec1e32e..a5064a3 100644
--- a/builtins/mapfile.def
+++ b/builtins/mapfile.def
@@ -195,13 +195,9 @@ mapfile (fd, line_count_goal, origin, nskip, callback_quantum, callback, array_n
   /* Reset the buffer for bash own stream */
   interrupt_immediately++;
   for (array_index = origin, line_count = 1; 
-       zgetline (fd, &line, &line_length, unbuffered_read) != -1;
-       array_index++, line_count++) 
+ 	zgetline (fd, &line, &line_length, unbuffered_read) != -1;
+	array_index++) 
     {
-      /* Have we exceeded # of lines to store? */
-      if (line_count_goal != 0 && line_count > line_count_goal) 
-	break;
-
       /* Remove trailing newlines? */
       if (flags & MAPF_CHOP)
 	do_chop (line);
@@ -217,6 +213,11 @@ mapfile (fd, line_count_goal, origin, nskip, callback_quantum, callback, array_n
 	}
 
       bind_array_element (entry, array_index, line, 0);
+
+      /* Have we exceeded # of lines to store? */
+      line_count++;
+      if (line_count_goal != 0 && line_count > line_count_goal) 
+	break;
     }
 
   xfree (line);
diff --git a/builtins/printf.def b/builtins/printf.def
index 7892cb5..71a7c00 100644
--- a/builtins/printf.def
+++ b/builtins/printf.def
@@ -255,6 +255,8 @@ printf_builtin (list)
 #endif
 	    {
 	      vflag = 1;
+	      if (vbsize == 0)
+		vbuf = xmalloc (vbsize = 16);
 	      vblen = 0;
 	      if (vbuf)
 		vbuf[0] = 0;
@@ -465,6 +467,9 @@ printf_builtin (list)
 		  secs = shell_start_time;	/* roughly $SECONDS */
 		else
 		  secs = arg;
+#if defined (HAVE_TZSET)
+		sv_tz ("TZ");		/* XXX -- just make sure */
+#endif
 		tm = localtime (&secs);
 		n = strftime (timebuf, sizeof (timebuf), timefmt, tm);
 		free (timefmt);
diff --git a/builtins/read.def b/builtins/read.def
index c4a668a..4915220 100644
--- a/builtins/read.def
+++ b/builtins/read.def
@@ -642,6 +642,12 @@ assign_vars:
 	  xfree (input_string);
 	  return EXECUTION_FAILURE;	/* readonly or noassign */
 	}
+      if (assoc_p (var))
+	{
+          builtin_error (_("%s: cannot convert associative to indexed array"), arrayname);
+	  xfree (input_string);
+	  return EXECUTION_FAILURE;	/* existing associative array */
+	}
       array_flush (array_cell (var));
 
       alist = list_string (input_string, ifs_chars, 0);
@@ -731,7 +737,7 @@ assign_vars:
 	      xfree (t1);
 	    }
 	  else
-	    var = bind_read_variable (varname, t);
+	    var = bind_read_variable (varname, t ? t : "");
 	}
       else
 	{
@@ -792,7 +798,7 @@ assign_vars:
       xfree (t);
     }
   else
-    var = bind_read_variable (list->word->word, input_string);
+    var = bind_read_variable (list->word->word, input_string ? input_string : "");
 
   if (var)
     {
diff --git a/builtins/shopt.def b/builtins/shopt.def
index 27685aa..6cd8c4f 100644
--- a/builtins/shopt.def
+++ b/builtins/shopt.def
@@ -61,6 +61,10 @@ $END
 #include "common.h"
 #include "bashgetopt.h"
 
+#if defined (READLINE)
+#  include "../bashline.h"
+#endif
+
 #if defined (HISTORY)
 #  include "../bashhist.h"
 #endif
@@ -94,7 +98,7 @@ extern int extended_glob;
 extern int hist_verify, history_reediting, perform_hostname_completion;
 extern int no_empty_command_completion;
 extern int force_fignore;
-extern int dircomplete_spelling;
+extern int dircomplete_spelling, dircomplete_expand;
 
 extern int enable_hostname_completion __P((int));
 #endif
@@ -121,6 +125,10 @@ static int set_compatibility_level __P((char *, int));
 static int set_restricted_shell __P((char *, int));
 #endif
 
+#if defined (READLINE)
+static int shopt_set_complete_direxpand __P((char *, int));
+#endif
+
 static int shopt_login_shell;
 static int shopt_compat31;
 static int shopt_compat32;
@@ -150,6 +158,7 @@ static struct {
   { "compat40", &shopt_compat40, set_compatibility_level },
   { "compat41", &shopt_compat41, set_compatibility_level },
 #if defined (READLINE)
+  { "direxpand", &dircomplete_expand, shopt_set_complete_direxpand },
   { "dirspell", &dircomplete_spelling, (shopt_set_func_t *)NULL },
 #endif
   { "dotglob", &glob_dot_filenames, (shopt_set_func_t *)NULL },
@@ -535,6 +544,17 @@ set_compatibility_level (option_name, mode)
   return 0;
 }
 
+#if defined (READLINE)
+static int
+shopt_set_complete_direxpand (option_name, mode)
+     char *option_name;
+     int mode;
+{
+  set_directory_hook ();
+  return 0;
+}
+#endif
+
 #if defined (RESTRICTED_SHELL)
 /* Don't allow the value of restricted_shell to be modified. */
 
diff --git a/command.h b/command.h
index 5d62046..fb71229 100644
--- a/command.h
+++ b/command.h
@@ -97,6 +97,7 @@ enum command_type { cm_for, cm_case, cm_while, cm_if, cm_simple, cm_select,
 #define W_HASCTLESC	0x200000	/* word contains literal CTLESC characters */
 #define W_ASSIGNASSOC	0x400000	/* word looks like associative array assignment */
 #define W_ARRAYIND	0x800000	/* word is an array index being expanded */
+#define W_ASSNGLOBAL	0x1000000	/* word is a global assignment to declare (declare/typeset -g) */
 
 /* Possible values for subshell_environment */
 #define SUBSHELL_ASYNC	0x01	/* subshell caused by `command &' */
diff --git a/doc/bash.1 b/doc/bash.1
index 0ba4f8e..103d27e 100644
--- a/doc/bash.1
+++ b/doc/bash.1
@@ -8948,6 +8948,16 @@ parameter expansion as a special character.  The single quotes must match
 quoted.  This is the behavior of posix mode through version 4.1.
 The default bash behavior remains as in previous versions.
 .TP 8
+.B direxpand
+If set,
+.B bash
+replaces directory names with the results of word expansion when performing
+filename completion.  This changes the contents of the readline editing
+buffer.
+If not set,
+.B bash
+attempts to preserve what the user typed.
+.TP 8
 .B dirspell
 If set,
 .B bash
diff --git a/doc/bashref.texi b/doc/bashref.texi
index b4fd8d3..ae982d5 100644
--- a/doc/bashref.texi
+++ b/doc/bashref.texi
@@ -4535,6 +4535,13 @@ parameter expansion as a special character.  The single quotes must match
 quoted.  This is the behavior of @sc{posix} mode through version 4.1.
 The default Bash behavior remains as in previous versions.
 
+@item direxpand
+If set, Bash
+replaces directory names with the results of word expansion when performing
+filename completion.  This changes the contents of the readline editing
+buffer.
+If not set, Bash attempts to preserve what the user typed.
+
 @item dirspell
 If set, Bash
 attempts spelling correction on directory names during word completion 
diff --git a/error.c b/error.c
index 72da9f5..1eac01c 100644
--- a/error.c
+++ b/error.c
@@ -200,7 +200,11 @@ report_error (format, va_alist)
 
   va_end (args);
   if (exit_immediately_on_error)
-    exit_shell (1);
+    {
+      if (last_command_exit_value == 0)
+	last_command_exit_value = 1;
+      exit_shell (last_command_exit_value);
+    }
 }
 
 void
diff --git a/execute_cmd.c b/execute_cmd.c
index 485b0c7..7432c85 100644
--- a/execute_cmd.c
+++ b/execute_cmd.c
@@ -2196,6 +2196,7 @@ execute_pipeline (command, asynchronous, pipe_in, pipe_out, fds_to_close)
   if (ignore_return && cmd)
     cmd->flags |= CMD_IGNORE_RETURN;
 
+#if defined (JOB_CONTROL)
   lastpipe_flag = 0;
   begin_unwind_frame ("lastpipe-exec");
   lstdin = -1;
@@ -2204,7 +2205,7 @@ execute_pipeline (command, asynchronous, pipe_in, pipe_out, fds_to_close)
      current shell environment. */
   if (lastpipe_opt && job_control == 0 && asynchronous == 0 && pipe_out == NO_PIPE && prev > 0)
     {
-      lstdin = move_to_high_fd (0, 0, 255);
+      lstdin = move_to_high_fd (0, 1, -1);
       if (lstdin > 0)
 	{
 	  do_piping (prev, pipe_out);
@@ -2215,15 +2216,19 @@ execute_pipeline (command, asynchronous, pipe_in, pipe_out, fds_to_close)
 	  lastpipe_jid = stop_pipeline (0, (COMMAND *)NULL);	/* XXX */
 	  add_unwind_protect (lastpipe_cleanup, lastpipe_jid);
 	}
-      cmd->flags |= CMD_LASTPIPE;
+      if (cmd)
+	cmd->flags |= CMD_LASTPIPE;
     }	  
   if (prev >= 0)
     add_unwind_protect (close, prev);
+#endif
 
   exec_result = execute_command_internal (cmd, asynchronous, prev, pipe_out, fds_to_close);
 
+#if defined (JOB_CONTROL)
   if (lstdin > 0)
     restore_stdin (lstdin);
+#endif
 
   if (prev >= 0)
     close (prev);
@@ -2246,7 +2251,9 @@ execute_pipeline (command, asynchronous, pipe_in, pipe_out, fds_to_close)
       unfreeze_jobs_list ();
     }
 
+#if defined (JOB_CONTROL)
   discard_unwind_frame ("lastpipe-exec");
+#endif
 
   return (exec_result);
 }
@@ -3575,13 +3582,13 @@ fix_assignment_words (words)
 {
   WORD_LIST *w;
   struct builtin *b;
-  int assoc;
+  int assoc, global;
 
   if (words == 0)
     return;
 
   b = 0;
-  assoc = 0;
+  assoc = global = 0;
 
   for (w = words; w; w = w->next)
     if (w->word->flags & W_ASSIGNMENT)
@@ -3598,12 +3605,17 @@ fix_assignment_words (words)
 #if defined (ARRAY_VARS)
 	if (assoc)
 	  w->word->flags |= W_ASSIGNASSOC;
+	if (global)
+	  w->word->flags |= W_ASSNGLOBAL;
 #endif
       }
 #if defined (ARRAY_VARS)
     /* Note that we saw an associative array option to a builtin that takes
        assignment statements.  This is a bit of a kludge. */
-    else if (w->word->word[0] == '-' && strchr (w->word->word, 'A'))
+    else if (w->word->word[0] == '-' && (strchr (w->word->word+1, 'A') || strchr (w->word->word+1, 'g')))
+#else
+    else if (w->word->word[0] == '-' && strchr (w->word->word+1, 'g'))
+#endif
       {
 	if (b == 0)
 	  {
@@ -3613,10 +3625,11 @@ fix_assignment_words (words)
 	    else if (b && (b->flags & ASSIGNMENT_BUILTIN))
 	      words->word->flags |= W_ASSNBLTIN;
 	  }
-	if (words->word->flags & W_ASSNBLTIN)
+	if ((words->word->flags & W_ASSNBLTIN) && strchr (w->word->word+1, 'A'))
 	  assoc = 1;
+	if ((words->word->flags & W_ASSNBLTIN) && strchr (w->word->word+1, 'g'))
+	  global = 1;
       }
-#endif
 }
 
 /* Return 1 if the file found by searching $PATH for PATHNAME, defaulting
diff --git a/expr.c b/expr.c
index 2177cfa..14cdca2 100644
--- a/expr.c
+++ b/expr.c
@@ -476,19 +476,23 @@ expassign ()
 
       if (special)
 	{
+	  if ((op == DIV || op == MOD) && value == 0)
+	    {
+	      if (noeval == 0)
+		evalerror (_("division by 0"));
+	      else
+	        value = 1;
+	    }
+
 	  switch (op)
 	    {
 	    case MUL:
 	      lvalue *= value;
 	      break;
 	    case DIV:
-	      if (value == 0)
-		evalerror (_("division by 0"));
 	      lvalue /= value;
 	      break;
 	    case MOD:
-	      if (value == 0)
-		evalerror (_("division by 0"));
 	      lvalue %= value;
 	      break;
 	    case PLUS:
@@ -804,7 +808,12 @@ exp2 ()
       val2 = exppower ();
 
       if (((op == DIV) || (op == MOD)) && (val2 == 0))
-	evalerror (_("division by 0"));
+	{
+	  if (noeval == 0)
+	    evalerror (_("division by 0"));
+	  else
+	    val2 = 1;
+	}
 
       if (op == MUL)
 	val1 *= val2;
diff --git a/lib/glob/glob.c b/lib/glob/glob.c
index c77618f..ad9b9d9 100644
--- a/lib/glob/glob.c
+++ b/lib/glob/glob.c
@@ -200,8 +200,11 @@ mbskipname (pat, dname, flags)
   wchar_t *pat_wc, *dn_wc;
   size_t pat_n, dn_n;
 
+  pat_wc = dn_wc = (wchar_t *)NULL;
+
   pat_n = xdupmbstowcs (&pat_wc, NULL, pat);
-  dn_n = xdupmbstowcs (&dn_wc, NULL, dname);
+  if (pat_n != (size_t)-1)
+    dn_n = xdupmbstowcs (&dn_wc, NULL, dname);
 
   ret = 0;
   if (pat_n != (size_t)-1 && dn_n !=(size_t)-1)
@@ -221,6 +224,8 @@ mbskipname (pat, dname, flags)
 	   (pat_wc[0] != L'\\' || pat_wc[1] != L'.'))
 	ret = 1;
     }
+  else
+    ret = skipname (pat, dname, flags);
 
   FREE (pat_wc);
   FREE (dn_wc);
@@ -266,8 +271,11 @@ wdequote_pathname (pathname)
   /* Convert the strings into wide characters.  */
   n = xdupmbstowcs (&wpathname, NULL, pathname);
   if (n == (size_t) -1)
-    /* Something wrong. */
-    return;
+    {
+      /* Something wrong.  Fall back to single-byte */
+      udequote_pathname (pathname);
+      return;
+    }
   orig_wpathname = wpathname;
 
   for (i = j = 0; wpathname && wpathname[i]; )
diff --git a/lib/glob/gmisc.c b/lib/glob/gmisc.c
index 84794cd..683035a 100644
--- a/lib/glob/gmisc.c
+++ b/lib/glob/gmisc.c
@@ -77,8 +77,8 @@ wmatchlen (wpat, wmax)
      wchar_t *wpat;
      size_t wmax;
 {
-  wchar_t wc, *wbrack;
-  int matlen, t, in_cclass, in_collsym, in_equiv;
+  wchar_t wc;
+  int matlen, bracklen, t, in_cclass, in_collsym, in_equiv;
 
   if (*wpat == 0)
     return (0);
@@ -118,58 +118,80 @@ wmatchlen (wpat, wmax)
 	  break;
 	case L'[':
 	  /* scan for ending `]', skipping over embedded [:...:] */
-	  wbrack = wpat;
+	  bracklen = 1;
 	  wc = *wpat++;
 	  do
 	    {
 	      if (wc == 0)
 		{
-	          matlen += wpat - wbrack - 1;	/* incremented below */
-	          break;
+		  wpat--;			/* back up to NUL */
+	          matlen += bracklen;
+	          goto bad_bracket;
 	        }
 	      else if (wc == L'\\')
 		{
-		  wc = *wpat++;
-		  if (*wpat == 0)
-		    break;
+		  /* *wpat == backslash-escaped character */
+		  bracklen++;
+		  /* If the backslash or backslash-escape ends the string,
+		     bail.  The ++wpat skips over the backslash escape */
+		  if (*wpat == 0 || *++wpat == 0)
+		    {
+		      matlen += bracklen;
+		      goto bad_bracket;
+		    }
 		}
 	      else if (wc == L'[' && *wpat == L':')	/* character class */
 		{
 		  wpat++;
+		  bracklen++;
 		  in_cclass = 1;
 		}
 	      else if (in_cclass && wc == L':' && *wpat == L']')
 		{
 		  wpat++;
+		  bracklen++;
 		  in_cclass = 0;
 		}
 	      else if (wc == L'[' && *wpat == L'.')	/* collating symbol */
 		{
 		  wpat++;
+		  bracklen++;
 		  if (*wpat == L']')	/* right bracket can appear as collating symbol */
-		    wpat++;
+		    {
+		      wpat++;
+		      bracklen++;
+		    }
 		  in_collsym = 1;
 		}
 	      else if (in_collsym && wc == L'.' && *wpat == L']')
 		{
 		  wpat++;
+		  bracklen++;
 		  in_collsym = 0;
 		}
 	      else if (wc == L'[' && *wpat == L'=')	/* equivalence class */
 		{
 		  wpat++;
+		  bracklen++;
 		  if (*wpat == L']')	/* right bracket can appear as equivalence class */
-		    wpat++;
+		    {
+		      wpat++;
+		      bracklen++;
+		    }
 		  in_equiv = 1;
 		}
 	      else if (in_equiv && wc == L'=' && *wpat == L']')
 		{
 		  wpat++;
+		  bracklen++;
 		  in_equiv = 0;
 		}
+	      else
+		bracklen++;
 	    }
 	  while ((wc = *wpat++) != L']');
 	  matlen++;		/* bracket expression can only match one char */
+bad_bracket:
 	  break;
 	}
     }
@@ -213,8 +235,8 @@ umatchlen (pat, max)
      char *pat;
      size_t max;
 {
-  char c, *brack;
-  int matlen, t, in_cclass, in_collsym, in_equiv;
+  char c;
+  int matlen, bracklen, t, in_cclass, in_collsym, in_equiv;
 
   if (*pat == 0)
     return (0);
@@ -254,58 +276,80 @@ umatchlen (pat, max)
 	  break;
 	case '[':
 	  /* scan for ending `]', skipping over embedded [:...:] */
-	  brack = pat;
+	  bracklen = 1;
 	  c = *pat++;
 	  do
 	    {
 	      if (c == 0)
 		{
-	          matlen += pat - brack - 1;	/* incremented below */
-	          break;
+		  pat--;			/* back up to NUL */
+		  matlen += bracklen;
+		  goto bad_bracket;
 	        }
 	      else if (c == '\\')
 		{
-		  c = *pat++;
-		  if (*pat == 0)
-		    break;
+		  /* *pat == backslash-escaped character */
+		  bracklen++;
+		  /* If the backslash or backslash-escape ends the string,
+		     bail.  The ++pat skips over the backslash escape */
+		  if (*pat == 0 || *++pat == 0)
+		    {
+		      matlen += bracklen;
+		      goto bad_bracket;
+		    }
 		}
 	      else if (c == '[' && *pat == ':')	/* character class */
 		{
 		  pat++;
+		  bracklen++;
 		  in_cclass = 1;
 		}
 	      else if (in_cclass && c == ':' && *pat == ']')
 		{
 		  pat++;
+		  bracklen++;
 		  in_cclass = 0;
 		}
 	      else if (c == '[' && *pat == '.')	/* collating symbol */
 		{
 		  pat++;
+		  bracklen++;
 		  if (*pat == ']')	/* right bracket can appear as collating symbol */
-		    pat++;
+		    {
+		      pat++;
+		      bracklen++;
+		    }
 		  in_collsym = 1;
 		}
 	      else if (in_collsym && c == '.' && *pat == ']')
 		{
 		  pat++;
+		  bracklen++;
 		  in_collsym = 0;
 		}
 	      else if (c == '[' && *pat == '=')	/* equivalence class */
 		{
 		  pat++;
+		  bracklen++;
 		  if (*pat == ']')	/* right bracket can appear as equivalence class */
-		    pat++;
+		    {
+		      pat++;
+		      bracklen++;
+		    }
 		  in_equiv = 1;
 		}
 	      else if (in_equiv && c == '=' && *pat == ']')
 		{
 		  pat++;
+		  bracklen++;
 		  in_equiv = 0;
 		}
+	      else
+		bracklen++;
 	    }
 	  while ((c = *pat++) != ']');
 	  matlen++;		/* bracket expression can only match one char */
+bad_bracket:
 	  break;
 	}
     }
diff --git a/lib/glob/xmbsrtowcs.c b/lib/glob/xmbsrtowcs.c
index 7abf727..4d8c043 100644
--- a/lib/glob/xmbsrtowcs.c
+++ b/lib/glob/xmbsrtowcs.c
@@ -35,6 +35,8 @@
 
 #if HANDLE_MULTIBYTE
 
+#define WSBUF_INC 32
+
 #ifndef FREE
 #  define FREE(x)	do { if (x) free (x); } while (0)
 #endif
@@ -148,7 +150,7 @@ xdupmbstowcs2 (destp, src)
   size_t wsbuf_size;	/* Size of WSBUF */
   size_t wcnum;		/* Number of wide characters in WSBUF */
   mbstate_t state;	/* Conversion State */
-  size_t wcslength;	/* Number of wide characters produced by the conversion. */
+  size_t n, wcslength;	/* Number of wide characters produced by the conversion. */
   const char *end_or_backslash;
   size_t nms;	/* Number of multibyte characters to convert at one time. */
   mbstate_t tmp_state;
@@ -171,7 +173,18 @@ xdupmbstowcs2 (destp, src)
       /* Compute the number of produced wide-characters. */
       tmp_p = p;
       tmp_state = state;
-      wcslength = mbsnrtowcs(NULL, &tmp_p, nms, 0, &tmp_state);
+
+      if (nms == 0 && *p == '\\')	/* special initial case */
+	nms = wcslength = 1;
+      else
+	wcslength = mbsnrtowcs (NULL, &tmp_p, nms, 0, &tmp_state);
+
+      if (wcslength == 0)
+	{
+	  tmp_p = p;		/* will need below */
+	  tmp_state = state;
+	  wcslength = 1;	/* take a single byte */
+	}
 
       /* Conversion failed. */
       if (wcslength == (size_t)-1)
@@ -186,7 +199,8 @@ xdupmbstowcs2 (destp, src)
 	{
 	  wchar_t *wstmp;
 
-	  wsbuf_size = wcnum+wcslength+1;	/* 1 for the L'\0' or the potential L'\\' */
+	  while (wsbuf_size < wcnum+wcslength+1) /* 1 for the L'\0' or the potential L'\\' */
+	    wsbuf_size += WSBUF_INC;
 
 	  wstmp = (wchar_t *) realloc (wsbuf, wsbuf_size * sizeof (wchar_t));
 	  if (wstmp == NULL)
@@ -199,10 +213,18 @@ xdupmbstowcs2 (destp, src)
 	}
 
       /* Perform the conversion. This is assumed to return 'wcslength'.
-       * It may set 'p' to NULL. */
-      mbsnrtowcs(wsbuf+wcnum, &p, nms, wsbuf_size-wcnum, &state);
+	 It may set 'p' to NULL. */
+      n = mbsnrtowcs(wsbuf+wcnum, &p, nms, wsbuf_size-wcnum, &state);
 
-      wcnum += wcslength;
+      /* Compensate for taking single byte on wcs conversion failure above. */
+      if (wcslength == 1 && (n == 0 || n == (size_t)-1))
+	{
+	  state = tmp_state;
+	  p = tmp_p;
+	  wsbuf[wcnum++] = *p++;
+	}
+      else
+        wcnum += wcslength;
 
       if (mbsinit (&state) && (p != NULL) && (*p == '\\'))
 	{
@@ -230,8 +252,6 @@ xdupmbstowcs2 (destp, src)
    If conversion is failed, the return value is (size_t)-1 and the values
    of DESTP and INDICESP are NULL. */
 
-#define WSBUF_INC 32
-
 size_t
 xdupmbstowcs (destp, indicesp, src)
     wchar_t **destp;	/* Store the pointer to the wide character string */
diff --git a/lib/readline/callback.c b/lib/readline/callback.c
index 4ee6361..7682cd0 100644
--- a/lib/readline/callback.c
+++ b/lib/readline/callback.c
@@ -148,6 +148,9 @@ rl_callback_read_char ()
 	  eof = _rl_vi_domove_callback (_rl_vimvcxt);
 	  /* Should handle everything, including cleanup, numeric arguments,
 	     and turning off RL_STATE_VIMOTION */
+	  if (RL_ISSTATE (RL_STATE_NUMERICARG) == 0)
+	    _rl_internal_char_cleanup ();
+
 	  return;
 	}
 #endif
diff --git a/lib/readline/input.c b/lib/readline/input.c
index 7c74c99..b49af88 100644
--- a/lib/readline/input.c
+++ b/lib/readline/input.c
@@ -409,7 +409,7 @@ rl_clear_pending_input ()
 int
 rl_read_key ()
 {
-  int c;
+  int c, r;
 
   rl_key_sequence_length++;
 
@@ -429,14 +429,18 @@ rl_read_key ()
 	{
 	  while (rl_event_hook)
 	    {
-	      if (rl_gather_tyi () < 0)	/* XXX - EIO */
+	      if (rl_get_char (&c) != 0)
+		break;
+		
+	      if ((r = rl_gather_tyi ()) < 0)	/* XXX - EIO */
 		{
 		  rl_done = 1;
 		  return ('\n');
 		}
+	      else if (r == 1)			/* read something */
+		continue;
+
 	      RL_CHECK_SIGNALS ();
-	      if (rl_get_char (&c) != 0)
-		break;
 	      if (rl_done)		/* XXX - experimental */
 		return ('\n');
 	      (*rl_event_hook) ();
diff --git a/lib/readline/vi_mode.c b/lib/readline/vi_mode.c
index 41e1dbb..4408053 100644
--- a/lib/readline/vi_mode.c
+++ b/lib/readline/vi_mode.c
@@ -1114,7 +1114,7 @@ rl_domove_read_callback (m)
       rl_beg_of_line (1, c);
       _rl_vi_last_motion = c;
       RL_UNSETSTATE (RL_STATE_VIMOTION);
-      return (0);
+      return (vidomove_dispatch (m));
     }
 #if defined (READLINE_CALLBACKS)
   /* XXX - these need to handle rl_universal_argument bindings */
@@ -1234,11 +1234,19 @@ rl_vi_delete_to (count, key)
       _rl_vimvcxt->motion = '$';
       r = rl_domove_motion_callback (_rl_vimvcxt);
     }
-  else if (vi_redoing)
+  else if (vi_redoing && _rl_vi_last_motion != 'd')	/* `dd' is special */
     {
       _rl_vimvcxt->motion = _rl_vi_last_motion;
       r = rl_domove_motion_callback (_rl_vimvcxt);
     }
+  else if (vi_redoing)		/* handle redoing `dd' here */
+    {
+      _rl_vimvcxt->motion = _rl_vi_last_motion;
+      rl_mark = rl_end;
+      rl_beg_of_line (1, key);
+      RL_UNSETSTATE (RL_STATE_VIMOTION);
+      r = vidomove_dispatch (_rl_vimvcxt);
+    }
 #if defined (READLINE_CALLBACKS)
   else if (RL_ISSTATE (RL_STATE_CALLBACK))
     {
@@ -1316,11 +1324,19 @@ rl_vi_change_to (count, key)
       _rl_vimvcxt->motion = '$';
       r = rl_domove_motion_callback (_rl_vimvcxt);
     }
-  else if (vi_redoing)
+  else if (vi_redoing && _rl_vi_last_motion != 'c')	/* `cc' is special */
     {
       _rl_vimvcxt->motion = _rl_vi_last_motion;
       r = rl_domove_motion_callback (_rl_vimvcxt);
     }
+  else if (vi_redoing)		/* handle redoing `cc' here */
+    {
+      _rl_vimvcxt->motion = _rl_vi_last_motion;
+      rl_mark = rl_end;
+      rl_beg_of_line (1, key);
+      RL_UNSETSTATE (RL_STATE_VIMOTION);
+      r = vidomove_dispatch (_rl_vimvcxt);
+    }
 #if defined (READLINE_CALLBACKS)
   else if (RL_ISSTATE (RL_STATE_CALLBACK))
     {
@@ -1377,6 +1393,19 @@ rl_vi_yank_to (count, key)
       _rl_vimvcxt->motion = '$';
       r = rl_domove_motion_callback (_rl_vimvcxt);
     }
+  else if (vi_redoing && _rl_vi_last_motion != 'y')	/* `yy' is special */
+    {
+      _rl_vimvcxt->motion = _rl_vi_last_motion;
+      r = rl_domove_motion_callback (_rl_vimvcxt);
+    }
+  else if (vi_redoing)			/* handle redoing `yy' here */
+    {
+      _rl_vimvcxt->motion = _rl_vi_last_motion;
+      rl_mark = rl_end;
+      rl_beg_of_line (1, key);
+      RL_UNSETSTATE (RL_STATE_VIMOTION);
+      r = vidomove_dispatch (_rl_vimvcxt);
+    }
 #if defined (READLINE_CALLBACKS)
   else if (RL_ISSTATE (RL_STATE_CALLBACK))
     {
diff --git a/lib/sh/eaccess.c b/lib/sh/eaccess.c
index d9bca8c..534c526 100644
--- a/lib/sh/eaccess.c
+++ b/lib/sh/eaccess.c
@@ -82,6 +82,8 @@ sh_stat (path, finfo)
      const char *path;
      struct stat *finfo;
 {
+  static char *pbuf = 0;
+
   if (*path == '\0')
     {
       errno = ENOENT;
@@ -106,7 +108,7 @@ sh_stat (path, finfo)
      trailing slash.  Make sure /dev/fd/xx really uses DEV_FD_PREFIX/xx.
      On most systems, with the notable exception of linux, this is
      effectively a no-op. */
-      char pbuf[32];
+      pbuf = xrealloc (pbuf, sizeof (DEV_FD_PREFIX) + strlen (path + 8));
       strcpy (pbuf, DEV_FD_PREFIX);
       strcat (pbuf, path + 8);
       return (stat (pbuf, finfo));
diff --git a/lib/sh/zread.c b/lib/sh/zread.c
index 0fd1199..5db21a9 100644
--- a/lib/sh/zread.c
+++ b/lib/sh/zread.c
@@ -160,14 +160,13 @@ void
 zsyncfd (fd)
      int fd;
 {
-  off_t off;
-  int r;
+  off_t off, r;
 
   off = lused - lind;
   r = 0;
   if (off > 0)
     r = lseek (fd, -off, SEEK_CUR);
 
-  if (r >= 0)
+  if (r != -1)
     lused = lind = 0;
 }
diff --git a/parse.y b/parse.y
index b5c94e7..dc78e7e 100644
--- a/parse.y
+++ b/parse.y
@@ -2499,7 +2499,7 @@ yylex ()
 	 We do this only if it is time to do so. Notice that only here
 	 is the mail alarm reset; nothing takes place in check_mail ()
 	 except the checking of mail.  Please don't change this. */
-      if (prompt_is_ps1 && time_to_check_mail ())
+      if (prompt_is_ps1 && parse_and_execute_level == 0 && time_to_check_mail ())
 	{
 	  check_mail ();
 	  reset_mail_timer ();
@@ -3842,6 +3842,7 @@ xparse_dolparen (base, string, indp, flags)
      int flags;
 {
   sh_parser_state_t ps;
+  sh_input_line_state_t ls;
   int orig_ind, nc, sflags;
   char *ret, *s, *ep, *ostring;
 
@@ -3849,10 +3850,12 @@ xparse_dolparen (base, string, indp, flags)
   orig_ind = *indp;
   ostring = string;
 
+/*itrace("xparse_dolparen: size = %d shell_input_line = `%s'", shell_input_line_size, shell_input_line);*/
   sflags = SEVAL_NONINT|SEVAL_NOHIST|SEVAL_NOFREE;
   if (flags & SX_NOLONGJMP)
     sflags |= SEVAL_NOLONGJMP;
   save_parser_state (&ps);
+  save_input_line_state (&ls);
 
   /*(*/
   parser_state |= PST_CMDSUBST|PST_EOFTOKEN;	/* allow instant ')' */ /*(*/
@@ -3861,6 +3864,8 @@ xparse_dolparen (base, string, indp, flags)
 
   restore_parser_state (&ps);
   reset_parser ();
+  /* reset_parser clears shell_input_line and associated variables */
+  restore_input_line_state (&ls);
   if (interactive)
     token_to_read = 0;
 
@@ -4895,6 +4900,9 @@ history_delimiting_chars (line)
       return (current_command_line_count == 2 ? "\n" : "");
     }
 
+  if (parser_state & PST_COMPASSIGN)
+    return (" ");
+
   /* First, handle some special cases. */
   /*(*/
   /* If we just read `()', assume it's a function definition, and don't
@@ -5135,6 +5143,9 @@ decode_prompt_string (string)
 	    case 'A':
 	      /* Make the current time/date into a string. */
 	      (void) time (&the_time);
+#if defined (HAVE_TZSET)
+	      sv_tz ("TZ");		/* XXX -- just make sure */
+#endif
 	      tm = localtime (&the_time);
 
 	      if (c == 'd')
@@ -5905,6 +5916,12 @@ save_parser_state (ps)
   ps->expand_aliases = expand_aliases;
   ps->echo_input_at_read = echo_input_at_read;
 
+  ps->token = token;
+  ps->token_buffer_size = token_buffer_size;
+  /* Force reallocation on next call to read_token_word */
+  token = 0;
+  token_buffer_size = 0;
+
   return (ps);
 }
 
@@ -5946,6 +5963,42 @@ restore_parser_state (ps)
 
   expand_aliases = ps->expand_aliases;
   echo_input_at_read = ps->echo_input_at_read;
+
+  FREE (token);
+  token = ps->token;
+  token_buffer_size = ps->token_buffer_size;
+}
+
+sh_input_line_state_t *
+save_input_line_state (ls)
+     sh_input_line_state_t *ls;
+{
+  if (ls == 0)
+    ls = (sh_input_line_state_t *)xmalloc (sizeof (sh_input_line_state_t));
+  if (ls == 0)
+    return ((sh_input_line_state_t *)NULL);
+
+  ls->input_line = shell_input_line;
+  ls->input_line_size = shell_input_line_size;
+  ls->input_line_len = shell_input_line_len;
+  ls->input_line_index = shell_input_line_index;
+
+  /* force reallocation */
+  shell_input_line = 0;
+  shell_input_line_size = shell_input_line_len = shell_input_line_index = 0;
+}
+
+void
+restore_input_line_state (ls)
+     sh_input_line_state_t *ls;
+{
+  FREE (shell_input_line);
+  shell_input_line = ls->input_line;
+  shell_input_line_size = ls->input_line_size;
+  shell_input_line_len = ls->input_line_len;
+  shell_input_line_index = ls->input_line_index;
+
+  set_line_mbstate ();
 }
 
 /************************************************
diff --git a/patchlevel.h b/patchlevel.h
index 85940d0..4e51dbc 100644
--- a/patchlevel.h
+++ b/patchlevel.h
@@ -25,6 +25,6 @@
    regexp `^#define[ 	]*PATCHLEVEL', since that's what support/mkversion.sh
    looks for to find the patch level (for the sccs version string). */
 
-#define PATCHLEVEL 0
+#define PATCHLEVEL 37
 
 #endif /* _PATCHLEVEL_H_ */
diff --git a/pathexp.c b/pathexp.c
index 42f21e4..f239956 100644
--- a/pathexp.c
+++ b/pathexp.c
@@ -196,7 +196,7 @@ quote_string_for_globbing (pathname, qflags)
 	{
 	  if ((qflags & QGLOB_FILENAME) && pathname[i+1] == '/')
 	    continue;
-	  if ((qflags & QGLOB_REGEXP) && ere_char (pathname[i+1]) == 0)
+	  if (pathname[i+1] != CTLESC && (qflags & QGLOB_REGEXP) && ere_char (pathname[i+1]) == 0)
 	    continue;
 	  temp[j++] = '\\';
 	  i++;
diff --git a/print_cmd.c b/print_cmd.c
index 0d646ec..cd54b2f 100644
--- a/print_cmd.c
+++ b/print_cmd.c
@@ -315,6 +315,7 @@ make_command_string_internal (command)
 	  cprintf ("( ");
 	  skip_this_indent++;
 	  make_command_string_internal (command->value.Subshell->command);
+	  PRINT_DEFERRED_HEREDOCS ("");
 	  cprintf (" )");
 	  break;
 
@@ -592,6 +593,7 @@ print_arith_for_command (arith_for_command)
   newline ("do\n");
   indentation += indentation_amount;
   make_command_string_internal (arith_for_command->action);
+  PRINT_DEFERRED_HEREDOCS ("");
   semicolon ();
   indentation -= indentation_amount;
   newline ("done");
@@ -653,6 +655,7 @@ print_group_command (group_command)
     }
 
   make_command_string_internal (group_command->command);
+  PRINT_DEFERRED_HEREDOCS ("");
 
   if (inside_function_def)
     {
diff --git a/shell.h b/shell.h
index 92685e1..38ab51f 100644
--- a/shell.h
+++ b/shell.h
@@ -136,6 +136,9 @@ typedef struct _sh_parser_state_t {
   int parser_state;
   int *token_state;
 
+  char *token;
+  int token_buffer_size;
+
   /* input line state -- line number saved elsewhere */
   int input_line_terminator;
   int eof_encountered;
@@ -166,6 +169,16 @@ typedef struct _sh_parser_state_t {
   
 } sh_parser_state_t;
 
+typedef struct _sh_input_line_state_t {
+  char *input_line;
+  int input_line_index;
+  int input_line_size;
+  int input_line_len;
+} sh_input_line_state_t;
+
 /* Let's try declaring these here. */
 extern sh_parser_state_t *save_parser_state __P((sh_parser_state_t *));
 extern void restore_parser_state __P((sh_parser_state_t *));
+
+extern sh_input_line_state_t *save_input_line_state __P((sh_input_line_state_t *));
+extern void restore_input_line_state __P((sh_input_line_state_t *));
diff --git a/sig.c b/sig.c
index 6bd1319..d38246d 100644
--- a/sig.c
+++ b/sig.c
@@ -46,6 +46,7 @@
 
 #if defined (READLINE)
 #  include "bashline.h"
+#  include <readline/readline.h>
 #endif
 
 #if defined (HISTORY)
@@ -62,6 +63,7 @@ extern int parse_and_execute_level, shell_initialized;
 #if defined (HISTORY)
 extern int history_lines_this_session;
 #endif
+extern int no_line_editing;
 
 extern void initialize_siglist ();
 
@@ -505,7 +507,10 @@ termsig_sighandler (sig)
     {
 #if defined (HISTORY)
       /* XXX - will inhibit history file being written */
-      history_lines_this_session = 0;
+#  if defined (READLINE)
+      if (interactive_shell == 0 || interactive == 0 || (sig != SIGHUP && sig != SIGTERM) || no_line_editing || (RL_ISSTATE (RL_STATE_READCMD) == 0))
+#  endif
+        history_lines_this_session = 0;
 #endif
       terminate_immediately = 0;
       termsig_handler (sig);
diff --git a/subst.c b/subst.c
index 0e83e56..937c71d 100644
--- a/subst.c
+++ b/subst.c
@@ -366,6 +366,11 @@ dump_word_flags (flags)
       f &= ~W_ASSNBLTIN;
       fprintf (stderr, "W_ASSNBLTIN%s", f ? "|" : "");
     }
+  if (f & W_ASSNGLOBAL)
+    {
+      f &= ~W_ASSNGLOBAL;
+      fprintf (stderr, "W_ASSNGLOBAL%s", f ? "|" : "");
+    }
   if (f & W_COMPASSIGN)
     {
       f &= ~W_COMPASSIGN;
@@ -1379,10 +1384,12 @@ extract_dollar_brace_string (string, sindex, quoted, flags)
   slen = strlen (string + *sindex) + *sindex;
 
   /* The handling of dolbrace_state needs to agree with the code in parse.y:
-     parse_matched_pair() */
-  dolbrace_state = 0;
-  if (quoted & (Q_HERE_DOCUMENT|Q_DOUBLE_QUOTES))
-    dolbrace_state = (flags & SX_POSIXEXP) ? DOLBRACE_QUOTE : DOLBRACE_PARAM;
+     parse_matched_pair().  The different initial value is to handle the
+     case where this function is called to parse the word in
+     ${param op word} (SX_WORD). */
+  dolbrace_state = (flags & SX_WORD) ? DOLBRACE_WORD : DOLBRACE_PARAM;
+  if ((quoted & (Q_HERE_DOCUMENT|Q_DOUBLE_QUOTES)) && (flags & SX_POSIXEXP))
+    dolbrace_state = DOLBRACE_QUOTE;
 
   i = *sindex;
   while (c = string[i])
@@ -2801,7 +2808,7 @@ do_assignment_internal (word, expand)
     }
   else if (assign_list)
     {
-      if (word->flags & W_ASSIGNARG)
+      if ((word->flags & W_ASSIGNARG) && (word->flags & W_ASSNGLOBAL) == 0)
 	aflags |= ASS_MKLOCAL;
       if (word->flags & W_ASSIGNASSOC)
 	aflags |= ASS_MKASSOC;
@@ -3371,7 +3378,7 @@ expand_string_for_rhs (string, quoted, dollar_at_p, has_dollar_at)
   if (string == 0 || *string == '\0')
     return (WORD_LIST *)NULL;
 
-  td.flags = 0;
+  td.flags = W_NOSPLIT2;		/* no splitting, remove "" and '' */
   td.word = string;
   tresult = call_expand_word_internal (&td, quoted, 1, dollar_at_p, has_dollar_at);
   return (tresult);
@@ -3704,7 +3711,10 @@ remove_quoted_nulls (string)
 	    break;
 	}
       else if (string[i] == CTLNUL)
-	i++;
+	{
+	  i++;
+	  continue;
+	}
 
       prev_i = i;
       ADVANCE_CHAR (string, slen, i);
@@ -4156,7 +4166,7 @@ match_wpattern (wstring, indices, wstrlen, wpat, mtype, sp, ep)
   simple = (wpat[0] != L'\\' && wpat[0] != L'*' && wpat[0] != L'?' && wpat[0] != L'[');
 #if defined (EXTENDED_GLOB)
   if (extended_glob)
-    simple |= (wpat[1] != L'(' || (wpat[0] != L'*' && wpat[0] != L'?' && wpat[0] != L'+' && wpat[0] != L'!' && wpat[0] != L'@')); /*)*/
+    simple &= (wpat[1] != L'(' || (wpat[0] != L'*' && wpat[0] != L'?' && wpat[0] != L'+' && wpat[0] != L'!' && wpat[0] != L'@')); /*)*/
 #endif
 
   /* If the pattern doesn't match anywhere in the string, go ahead and
@@ -4607,6 +4617,7 @@ expand_word_unsplit (word, quoted)
   if (ifs_firstc == 0)
 #endif
     word->flags |= W_NOSPLIT;
+  word->flags |= W_NOSPLIT2;
   result = call_expand_word_internal (word, quoted, 0, (int *)NULL, (int *)NULL);
   expand_no_split_dollar_star = 0;
 
@@ -5798,6 +5809,16 @@ parameter_brace_expand_rhs (name, value, c, quoted, qdollaratp, hasdollarat)
 	 is the only expansion that creates more than one word. */
       if (qdollaratp && ((hasdol && quoted) || l->next))
 	*qdollaratp = 1;
+      /* If we have a quoted null result (QUOTED_NULL(temp)) and the word is
+	 a quoted null (l->next == 0 && QUOTED_NULL(l->word->word)), the
+	 flags indicate it (l->word->flags & W_HASQUOTEDNULL), and the
+	 expansion is quoted (quoted & (Q_HERE_DOCUMENT|Q_DOUBLE_QUOTES))
+	 (which is more paranoia than anything else), we need to return the
+	 quoted null string and set the flags to indicate it. */
+      if (l->next == 0 && (quoted & (Q_HERE_DOCUMENT|Q_DOUBLE_QUOTES)) && QUOTED_NULL(temp) && QUOTED_NULL(l->word->word) && (l->word->flags & W_HASQUOTEDNULL))
+	{
+	  w->flags |= W_HASQUOTEDNULL;
+	}
       dispose_words (l);
     }
   else if ((quoted & (Q_HERE_DOCUMENT|Q_DOUBLE_QUOTES)) && hasdol)
@@ -7176,7 +7197,7 @@ parameter_brace_expand (string, indexp, quoted, pflags, quoted_dollar_atp, conta
     {
       /* Extract the contents of the ${ ... } expansion
 	 according to the Posix.2 rules. */
-      value = extract_dollar_brace_string (string, &sindex, quoted, (c == '%' || c == '#') ? SX_POSIXEXP : 0);
+      value = extract_dollar_brace_string (string, &sindex, quoted, (c == '%' || c == '#' || c =='/' || c == '^' || c == ',' || c ==':') ? SX_POSIXEXP|SX_WORD : SX_WORD);
       if (string[sindex] == RBRACE)
 	sindex++;
       else
@@ -7268,6 +7289,7 @@ parameter_brace_expand (string, indexp, quoted, pflags, quoted_dollar_atp, conta
     default:
     case '\0':
     bad_substitution:
+      last_command_exit_value = EXECUTION_FAILURE;
       report_error (_("%s: bad substitution"), string ? string : "??");
       FREE (value);
       FREE (temp);
@@ -7900,7 +7922,7 @@ expand_word_internal (word, quoted, isexp, contains_dollar_at, expanded_somethin
 
   /* State flags */
   int had_quoted_null;
-  int has_dollar_at;
+  int has_dollar_at, temp_has_dollar_at;
   int tflag;
   int pflags;			/* flags passed to param_expand */
 
@@ -8105,13 +8127,14 @@ add_string:
 	  if (expanded_something)
 	    *expanded_something = 1;
 
-	  has_dollar_at = 0;
+	  temp_has_dollar_at = 0;
 	  pflags = (word->flags & W_NOCOMSUB) ? PF_NOCOMSUB : 0;
 	  if (word->flags & W_NOSPLIT2)
 	    pflags |= PF_NOSPLIT2;
 	  tword = param_expand (string, &sindex, quoted, expanded_something,
-			       &has_dollar_at, &quoted_dollar_at,
+			       &temp_has_dollar_at, &quoted_dollar_at,
 			       &had_quoted_null, pflags);
+	  has_dollar_at += temp_has_dollar_at;
 
 	  if (tword == &expand_wdesc_error || tword == &expand_wdesc_fatal)
 	    {
@@ -8129,6 +8152,14 @@ add_string:
 	  temp = tword->word;
 	  dispose_word_desc (tword);
 
+	  /* Kill quoted nulls; we will add them back at the end of
+	     expand_word_internal if nothing else in the string */
+	  if (had_quoted_null && temp && QUOTED_NULL (temp))
+	    {
+	      FREE (temp);
+	      temp = (char *)NULL;
+	    }
+
 	  goto add_string;
 	  break;
 
@@ -8244,9 +8275,10 @@ add_twochars:
 
 	      temp = (char *)NULL;
 
-	      has_dollar_at = 0;
+	      temp_has_dollar_at = 0;	/* XXX */
 	      /* Need to get W_HASQUOTEDNULL flag through this function. */
-	      list = expand_word_internal (tword, Q_DOUBLE_QUOTES, 0, &has_dollar_at, (int *)NULL);
+	      list = expand_word_internal (tword, Q_DOUBLE_QUOTES, 0, &temp_has_dollar_at, (int *)NULL);
+	      has_dollar_at += temp_has_dollar_at;
 
 	      if (list == &expand_word_error || list == &expand_word_fatal)
 		{
@@ -8533,7 +8565,7 @@ finished_with_string:
 	tword->flags |= W_NOEXPAND;	/* XXX */
       if (quoted & (Q_HERE_DOCUMENT|Q_DOUBLE_QUOTES))
 	tword->flags |= W_QUOTED;
-      if (had_quoted_null)
+      if (had_quoted_null && QUOTED_NULL (istring))
 	tword->flags |= W_HASQUOTEDNULL;
       list = make_word_list (tword, (WORD_LIST *)NULL);
     }
@@ -8564,7 +8596,7 @@ finished_with_string:
 	    tword->flags |= W_NOGLOB;
 	  if (word->flags & W_NOEXPAND)
 	    tword->flags |= W_NOEXPAND;
-	  if (had_quoted_null)
+	  if (had_quoted_null && QUOTED_NULL (istring))
 	    tword->flags |= W_HASQUOTEDNULL;	/* XXX */
 	  list = make_word_list (tword, (WORD_LIST *)NULL);
 	}
diff --git a/subst.h b/subst.h
index ae388fd..914fffe 100644
--- a/subst.h
+++ b/subst.h
@@ -56,6 +56,7 @@
 #define SX_NOLONGJMP	0x0040	/* don't longjmp on fatal error */
 #define SX_ARITHSUB	0x0080	/* extracting $(( ... )) (currently unused) */
 #define SX_POSIXEXP	0x0100	/* extracting new Posix pattern removal expansions in extract_dollar_brace_string */
+#define SX_WORD		0x0200	/* extracting word in ${param op word} */
 
 /* Remove backslashes which are quoting backquotes from STRING.  Modifies
    STRING, and returns a pointer to it. */
diff --git a/support/shobj-conf b/support/shobj-conf
index 5a63e80..c61dc78 100755
--- a/support/shobj-conf
+++ b/support/shobj-conf
@@ -157,7 +157,7 @@ freebsd[4-9]*|freebsdelf*|dragonfly*)
 	;;
 
 # Darwin/MacOS X
-darwin[89]*|darwin10*)
+darwin[89]*|darwin1[012]*)
 	SHOBJ_STATUS=supported
 	SHLIB_STATUS=supported
 	
@@ -186,7 +186,7 @@ darwin*|macosx*)
 	SHLIB_LIBSUFF='dylib'
 
 	case "${host_os}" in
-	darwin[789]*|darwin10*)	SHOBJ_LDFLAGS=''
+	darwin[789]*|darwin1[012]*)	SHOBJ_LDFLAGS=''
 			SHLIB_XLDFLAGS='-dynamiclib -arch_only `/usr/bin/arch` -install_name $(libdir)/$@ -current_version $(SHLIB_MAJOR)$(SHLIB_MINOR) -compatibility_version $(SHLIB_MAJOR) -v'
 			;;
 	*)		SHOBJ_LDFLAGS='-dynamic'
diff --git a/tests/shopt.right b/tests/shopt.right
index 4080503..0d3c08c 100644
--- a/tests/shopt.right
+++ b/tests/shopt.right
@@ -12,6 +12,7 @@ shopt -u compat31
 shopt -u compat32
 shopt -u compat40
 shopt -u compat41
+shopt -u direxpand
 shopt -u dirspell
 shopt -u dotglob
 shopt -u execfail
@@ -68,6 +69,7 @@ shopt -u compat31
 shopt -u compat32
 shopt -u compat40
 shopt -u compat41
+shopt -u direxpand
 shopt -u dirspell
 shopt -u dotglob
 shopt -u execfail
@@ -101,6 +103,7 @@ compat31       	off
 compat32       	off
 compat40       	off
 compat41       	off
+direxpand      	off
 dirspell       	off
 dotglob        	off
 execfail       	off
diff --git a/variables.c b/variables.c
index 3c20c3c..7bb850f 100644
--- a/variables.c
+++ b/variables.c
@@ -3653,6 +3653,22 @@ n_shell_variables ()
   return n;
 }
 
+int
+chkexport (name)
+     char *name;
+{
+  SHELL_VAR *v;
+
+  v = find_variable (name);
+  if (v && exported_p (v))
+    {
+      array_needs_making = 1;
+      maybe_make_export_env ();
+      return 1;
+    }
+  return 0;
+}
+
 void
 maybe_make_export_env ()
 {
@@ -4214,7 +4230,7 @@ static struct name_and_function special_vars[] = {
   { "TEXTDOMAIN", sv_locale },
   { "TEXTDOMAINDIR", sv_locale },
 
-#if defined (HAVE_TZSET) && defined (PROMPT_STRING_DECODE)
+#if defined (HAVE_TZSET)
   { "TZ", sv_tz },
 #endif
 
@@ -4558,12 +4574,13 @@ sv_histtimefmt (name)
 }
 #endif /* HISTORY */
 
-#if defined (HAVE_TZSET) && defined (PROMPT_STRING_DECODE)
+#if defined (HAVE_TZSET)
 void
 sv_tz (name)
      char *name;
 {
-  tzset ();
+  if (chkexport (name))
+    tzset ();
 }
 #endif
 
diff --git a/variables.h b/variables.h
index 7041ca9..84e92bb 100644
--- a/variables.h
+++ b/variables.h
@@ -313,6 +313,7 @@ extern void set_func_auto_export __P((const char *));
 
 extern void sort_variables __P((SHELL_VAR **));
 
+extern int chkexport __P((char *));
 extern void maybe_make_export_env __P((void));
 extern void update_export_env_inplace __P((char *, int, char *));
 extern void put_command_name_into_env __P((char *));
