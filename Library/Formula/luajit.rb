require 'formula'

class Luajit < Formula
  homepage 'http://luajit.org/luajit.html'
  url 'http://luajit.org/download/LuaJIT-2.0.0-beta11.tar.gz'
  sha1 '296776278e926af0c56b6748548661934f0a5d2d'
  head 'http://luajit.org/git/luajit-2.0.git'

  def patches; DATA; end

  skip_clean 'lib/lua/5.1', 'share/lua/5.1'

  option "enable-debug", "Build with debugging symbols"

  def install
    # 1 - Remove the '-O2' so we can set Og if needed.  Leave the -fomit part.
    # 2 - Override the hardcoded gcc.
    # 3 - Remove the '-march=i686' so we can set the march in cflags.
    # All three changes should persist and were discussed upstream.
    inreplace 'src/Makefile' do |f|
      f.change_make_var! 'CCOPT', '-fomit-frame-pointer'
      f.change_make_var! 'CC', ENV.cc
      f.change_make_var! 'CCOPT_x86', ''
    end

    ENV.O2                          # Respect the developer's choice.
    args = ["PREFIX=#{prefix}"]
    if build.include? 'enable-debug' then
      ENV.Og if ENV.compiler == :clang
      args << 'CCDEBUG=-g'
    end

    bldargs = args
    bldargs << 'amalg'
    system 'make', *bldargs
    args << 'install'
    system 'make', *args            # Build requires args during install

    # Non-versioned symlink
    version = build.head? ? "2.0.0-beta11" : @version
    ln_s bin/"luajit-#{version}", bin/"luajit"
  end
end

__END__
Fix Android/x86 build.
Fix recording of equality comparisons with __eq metamethods.
Fix detection of immutable upvalues.

--- a/src/lj_arch.h
+++ b/src/lj_arch.h
@@ -395,7 +395,7 @@
 #endif

 /* Various workarounds for embedded operating systems. */
-#if defined(__ANDROID__) || defined(__symbian__)
+#if (defined(__ANDROID__) && !defined(LJ_TARGET_X86ORX64)) || defined(__symbian__)
 #define LUAJIT_NO_LOG2
 #endif
 #if defined(__symbian__)
--- a/src/lj_lex.h
+++ b/src/lj_lex.h
@@ -41,9 +41,11 @@ typedef struct BCInsLine {

 /* Info for local variables. Only used during bytecode generation. */
 typedef struct VarInfo {
-  GCRef name;		/* Local variable name. */
+  GCRef name;		/* Local variable name or goto/label name. */
   BCPos startpc;	/* First point where the local variable is active. */
   BCPos endpc;		/* First point where the local variable is dead. */
+  uint8_t slot;		/* Variable slot. */
+  uint8_t info;		/* Variable/goto/label info. */
 } VarInfo;

 /* Lua lexer state. */
--- a/src/lj_parse.c
+++ b/src/lj_parse.c
@@ -110,19 +110,12 @@ typedef struct FuncScope {

 /* Index into variable stack. */
 typedef uint16_t VarIndex;
-#define LJ_MAX_VSTACK		65536
+#define LJ_MAX_VSTACK		(65536 - LJ_MAX_UPVAL)

-/* Flags stored in upper bits of endpc. */
-#define VSTACK_MASK		0x1fffffff	/* Mask for actual endpc. */
-#define VSTACK_VAR_RW		0x80000000	/* R/W variable. */
-#define VSTACK_GOTO		0x40000000	/* Pending goto. */
-#define VSTACK_LABEL		0x20000000	/* Label. */
-
-/* Upvalue map. */
-typedef struct UVMap {
-  VarIndex vidx;		/* Varinfo index. */
-  uint16_t slot;		/* Slot or parent upvalue index. */
-} UVMap;
+/* Variable/goto/label info. */
+#define VSTACK_VAR_RW		0x01	/* R/W variable. */
+#define VSTACK_GOTO		0x02	/* Pending goto. */
+#define VSTACK_LABEL		0x04	/* Label. */

 /* Per-function state. */
 typedef struct FuncState {
@@ -146,7 +139,8 @@ typedef struct FuncState {
   uint8_t framesize;		/* Fixed frame size. */
   uint8_t nuv;			/* Number of upvalues */
   VarIndex varmap[LJ_MAX_LOCVAR];  /* Map from register to variable idx. */
-  UVMap uvloc[LJ_MAX_UPVAL];	/* Map from upvalue to variable idx and slot. */
+  VarIndex uvmap[LJ_MAX_UPVAL];	/* Map from upvalue to variable idx. */
+  VarIndex uvtmp[LJ_MAX_UPVAL];	/* Temporary upvalue map. */
 } FuncState;

 /* Binary and unary operators. ORDER OPR */
@@ -621,12 +615,12 @@ static void bcemit_store(FuncState *fs, ExpDesc *var, ExpDesc *e)
 {
   BCIns ins;
   if (var->k == VLOCAL) {
-    fs->ls->vstack[var->u.s.aux].endpc |= VSTACK_VAR_RW;
+    fs->ls->vstack[var->u.s.aux].info |= VSTACK_VAR_RW;
     expr_free(fs, e);
     expr_toreg(fs, e, var->u.s.info);
     return;
   } else if (var->k == VUPVAL) {
-    fs->ls->vstack[var->u.s.aux].endpc |= VSTACK_VAR_RW;
+    fs->ls->vstack[var->u.s.aux].info |= VSTACK_VAR_RW;
     expr_toval(fs, e);
     if (e->k <= VKTRUE)
       ins = BCINS_AD(BC_USETP, var->u.s.info, const_pri(e));
@@ -1059,12 +1053,14 @@ static void var_new(LexState *ls, BCReg n, GCstr *name)
 static void var_add(LexState *ls, BCReg nvars)
 {
   FuncState *fs = ls->fs;
-  fs->nactvar = (uint8_t)(fs->nactvar + nvars);
-  for (; nvars; nvars--) {
-    VarInfo *v = &var_get(ls, fs, fs->nactvar - nvars);
+  BCReg nactvar = fs->nactvar;
+  while (nvars--) {
+    VarInfo *v = &var_get(ls, fs, nactvar);
     v->startpc = fs->pc;
-    v->endpc = 0;
+    v->slot = nactvar++;
+    v->info = 0;
   }
+  fs->nactvar = nactvar;
 }

 /* Remove local variables. */
@@ -1072,7 +1068,7 @@ static void var_remove(LexState *ls, BCReg tolevel)
 {
   FuncState *fs = ls->fs;
   while (fs->nactvar > tolevel)
-    var_get(ls, fs, --fs->nactvar).endpc |= fs->pc;
+    var_get(ls, fs, --fs->nactvar).endpc = fs->pc;
 }

 /* Lookup local variable name. */
@@ -1091,14 +1087,13 @@ static MSize var_lookup_uv(FuncState *fs, MSize vidx, ExpDesc *e)
 {
   MSize i, n = fs->nuv;
   for (i = 0; i < n; i++)
-    if (fs->uvloc[i].vidx == vidx)
+    if (fs->uvmap[i] == vidx)
       return i;  /* Already exists. */
   /* Otherwise create a new one. */
   checklimit(fs, fs->nuv, LJ_MAX_UPVAL, "upvalues");
   lua_assert(e->k == VLOCAL || e->k == VUPVAL);
-  fs->uvloc[n].vidx = (uint16_t)vidx;
-  fs->uvloc[n].slot = (uint16_t)(e->u.s.info |
-				 (e->k == VLOCAL ? PROTO_UV_LOCAL : 0));
+  fs->uvmap[n] = (uint16_t)vidx;
+  fs->uvtmp[n] = (uint16_t)(e->k == VLOCAL ? vidx : LJ_MAX_VSTACK+e->u.s.info);
   fs->nuv = n+1;
   return n;
 }
@@ -1138,7 +1133,7 @@ static MSize var_lookup_(FuncState *fs, GCstr *name, ExpDesc *e, int first)
 /* -- Goto an label handling ---------------------------------------------- */

 /* Add a new goto or label. */
-static MSize gola_new(LexState *ls, GCstr *name, uint32_t type, BCPos pc)
+static MSize gola_new(LexState *ls, GCstr *name, uint8_t info, BCPos pc)
 {
   FuncState *fs = ls->fs;
   MSize vtop = ls->vtop;
@@ -1151,15 +1146,15 @@ static MSize gola_new(LexState *ls, GCstr *name, uint32_t type, BCPos pc)
   /* NOBARRIER: name is anchored in fs->kt and ls->vstack is not a GCobj. */
   setgcref(ls->vstack[vtop].name, obj2gco(name));
   ls->vstack[vtop].startpc = pc;
-  ls->vstack[vtop].endpc = fs->nactvar | type;
+  ls->vstack[vtop].slot = (uint8_t)fs->nactvar;
+  ls->vstack[vtop].info = info;
   ls->vtop = vtop+1;
   return vtop;
 }

-#define gola_nactvar(v)		((uint8_t)((v)->endpc))
-#define gola_isgoto(v)		((v)->endpc & VSTACK_GOTO)
-#define gola_islabel(v)		((v)->endpc & VSTACK_LABEL)
-#define gola_isgotolabel(v)	((v)->endpc & (VSTACK_GOTO|VSTACK_LABEL))
+#define gola_isgoto(v)		((v)->info & VSTACK_GOTO)
+#define gola_islabel(v)		((v)->info & VSTACK_LABEL)
+#define gola_isgotolabel(v)	((v)->info & (VSTACK_GOTO|VSTACK_LABEL))

 /* Patch goto to jump to label. */
 static void gola_patch(LexState *ls, VarInfo *vg, VarInfo *vl)
@@ -1167,7 +1162,7 @@ static void gola_patch(LexState *ls, VarInfo *vg, VarInfo *vl)
   FuncState *fs = ls->fs;
   BCPos pc = vg->startpc;
   setgcrefnull(vg->name);  /* Invalidate pending goto. */
-  setbc_a(&fs->bcbase[pc].ins, gola_nactvar(vl));
+  setbc_a(&fs->bcbase[pc].ins, vl->slot);
   jmp_patch(fs, pc, vl->startpc);
 }

@@ -1179,7 +1174,7 @@ static void gola_close(LexState *ls, VarInfo *vg)
   BCIns *ip = &fs->bcbase[pc].ins;
   lua_assert(gola_isgoto(vg));
   lua_assert(bc_op(*ip) == BC_JMP || bc_op(*ip) == BC_UCLO);
-  setbc_a(ip, gola_nactvar(vg));
+  setbc_a(ip, vg->slot);
   if (bc_op(*ip) == BC_JMP) {
     BCPos next = jmp_next(fs, pc);
     if (next != NO_JMP) jmp_patch(fs, next, pc);  /* Jump to UCLO. */
@@ -1195,8 +1190,8 @@ static void gola_resolve(LexState *ls, FuncScope *bl, MSize idx)
   VarInfo *vl = ls->vstack + idx;
   for (; vg < vl; vg++)
     if (gcrefeq(vg->name, vl->name) && gola_isgoto(vg)) {
-      if (gola_nactvar(vg) < gola_nactvar(vl)) {
-	GCstr *name = strref(var_get(ls, ls->fs, gola_nactvar(vg)).name);
+      if (vg->slot < vl->slot) {
+	GCstr *name = strref(var_get(ls, ls->fs, vg->slot).name);
	lua_assert((uintptr_t)name >= VARNAME__MAX);
	ls->linenumber = ls->fs->bcbase[vg->startpc].line;
	lua_assert(strref(vg->name) != NAME_BREAK);
@@ -1220,14 +1215,14 @@ static void gola_fixup(LexState *ls, FuncScope *bl)
	setgcrefnull(v->name);  /* Invalidate label that goes out of scope. */
	for (vg = v+1; vg < ve; vg++)  /* Resolve pending backward gotos. */
	  if (strref(vg->name) == name && gola_isgoto(vg)) {
-	    if ((bl->flags&FSCOPE_UPVAL) && gola_nactvar(vg) > gola_nactvar(v))
+	    if ((bl->flags&FSCOPE_UPVAL) && vg->slot > v->slot)
	      gola_close(ls, vg);
	    gola_patch(ls, vg, v);
	  }
       } else if (gola_isgoto(v)) {
	if (bl->prev) {  /* Propagate goto or break to outer scope. */
	  bl->prev->flags |= name == NAME_BREAK ? FSCOPE_BREAK : FSCOPE_GOLA;
-	  v->endpc = bl->nactvar | VSTACK_GOTO;
+	  v->slot = bl->nactvar;
	  if ((bl->flags & FSCOPE_UPVAL))
	    gola_close(ls, v);
	} else {  /* No outer scope: undefined goto label or no loop. */
@@ -1314,6 +1309,23 @@ static void fs_fixup_bc(FuncState *fs, GCproto *pt, BCIns *bc, MSize n)
     bc[i] = base[i].ins;
 }

+/* Fixup upvalues for child prototype, step #2. */
+static void fs_fixup_uv2(FuncState *fs, GCproto *pt)
+{
+  VarInfo *vstack = fs->ls->vstack;
+  uint16_t *uv = proto_uv(pt);
+  MSize i, n = pt->sizeuv;
+  for (i = 0; i < n; i++) {
+    VarIndex vidx = uv[i];
+    if (vidx >= LJ_MAX_VSTACK)
+      uv[i] = vidx - LJ_MAX_VSTACK;
+    else if ((vstack[vidx].info & VSTACK_VAR_RW))
+      uv[i] = vstack[vidx].slot | PROTO_UV_LOCAL;
+    else
+      uv[i] = vstack[vidx].slot | PROTO_UV_LOCAL | PROTO_UV_IMMUTABLE;
+  }
+}
+
 /* Fixup constants for prototype. */
 static void fs_fixup_k(FuncState *fs, GCproto *pt, void *kptr)
 {
@@ -1360,28 +1372,19 @@ static void fs_fixup_k(FuncState *fs, GCproto *pt, void *kptr)
	GCobj *o = gcV(&n->key);
	setgcref(((GCRef *)kptr)[~kidx], o);
	lj_gc_objbarrier(fs->L, pt, o);
+	if (tvisproto(&n->key))
+	  fs_fixup_uv2(fs, gco2pt(o));
       }
     }
   }
 }

-/* Fixup upvalues for prototype. */
-static void fs_fixup_uv(FuncState *fs, GCproto *pt, uint16_t *uv)
+/* Fixup upvalues for prototype, step #1. */
+static void fs_fixup_uv1(FuncState *fs, GCproto *pt, uint16_t *uv)
 {
-  VarInfo *vstack;
-  UVMap *uvloc;
-  MSize i, n = fs->nuv;
   setmref(pt->uv, uv);
-  pt->sizeuv = n;
-  vstack = fs->ls->vstack;
-  uvloc = fs->uvloc;
-  for (i = 0; i < n; i++) {
-    uint16_t slot = uvloc[i].slot;
-    uint16_t vidx = uvloc[i].vidx;
-    if ((slot & PROTO_UV_LOCAL) && !(vstack[vidx].endpc & VSTACK_VAR_RW))
-      slot |= PROTO_UV_IMMUTABLE;
-    uv[i] = slot;
-  }
+  pt->sizeuv = fs->nuv;
+  memcpy(uv, fs->uvtmp, fs->nuv*sizeof(VarIndex));
 }

 #ifndef LUAJIT_DISABLE_DEBUGINFO
@@ -1462,13 +1465,13 @@ static void fs_buf_uleb128(LexState *ls, uint32_t v)
 /* Prepare variable info for prototype. */
 static size_t fs_prep_var(LexState *ls, FuncState *fs, size_t *ofsvar)
 {
-  VarInfo *vs = fs->ls->vstack, *ve;
+  VarInfo *vs =ls->vstack, *ve;
   MSize i, n;
   BCPos lastpc;
   lj_str_resetbuf(&ls->sb);  /* Copy to temp. string buffer. */
   /* Store upvalue names. */
   for (i = 0, n = fs->nuv; i < n; i++) {
-    GCstr *s = strref(vs[fs->uvloc[i].vidx].name);
+    GCstr *s = strref(vs[fs->uvmap[i]].name);
     MSize len = s->len+1;
     fs_buf_need(ls, len);
     fs_buf_str(ls, strdata(s), len);
@@ -1490,7 +1493,7 @@ static size_t fs_prep_var(LexState *ls, FuncState *fs, size_t *ofsvar)
       }
       startpc = vs->startpc;
       fs_buf_uleb128(ls, startpc-lastpc);
-      fs_buf_uleb128(ls, (vs->endpc & VSTACK_MASK)-startpc);
+      fs_buf_uleb128(ls, vs->endpc-startpc);
       lastpc = startpc;
     }
   }
@@ -1600,7 +1603,7 @@ static GCproto *fs_finish(LexState *ls, BCLine line)
   *(uint32_t *)((char *)pt + ofsk - sizeof(GCRef)*(fs->nkgc+1)) = 0;
   fs_fixup_bc(fs, pt, (BCIns *)((char *)pt + sizeof(GCproto)), fs->pc);
   fs_fixup_k(fs, pt, (void *)((char *)pt + ofsk));
-  fs_fixup_uv(fs, pt, (uint16_t *)((char *)pt + ofsuv));
+  fs_fixup_uv1(fs, pt, (uint16_t *)((char *)pt + ofsuv));
   fs_fixup_line(fs, pt, (void *)((char *)pt + ofsli), numline);
   fs_fixup_var(ls, pt, (uint8_t *)((char *)pt + ofsdbg), ofsvar);

@@ -2265,7 +2268,9 @@ static void parse_local(LexState *ls)
     bcreg_reserve(fs, 1);
     var_add(ls, 1);
     parse_body(ls, &b, 0, ls->linenumber);
-    bcemit_store(fs, &v, &b);
+    /* bcemit_store(fs, &v, &b) without setting VSTACK_VAR_RW. */
+    expr_free(fs, &b);
+    expr_toreg(fs, &b, v.u.s.info);
     /* The upvalue is in scope, but the local is only valid after the store. */
     var_get(ls, fs, fs->nactvar - 1).startpc = fs->pc;
   } else {  /* Local variable declaration. */
@@ -2371,7 +2376,7 @@ static void parse_goto(LexState *ls)
   GCstr *name = lex_str(ls);
   VarInfo *vl = gola_findlabel(ls, name);
   if (vl)  /* Treat backwards goto within same scope like a loop. */
-    bcemit_AJ(fs, BC_LOOP, gola_nactvar(vl), -1);  /* No BC range check. */
+    bcemit_AJ(fs, BC_LOOP, vl->slot, -1);  /* No BC range check. */
   fs->bl->flags |= FSCOPE_GOLA;
   gola_new(ls, name, VSTACK_GOTO, bcemit_jmp(fs));
 }
@@ -2404,7 +2409,7 @@ static void parse_label(LexState *ls)
   }
   /* Trailing label is considered to be outside of scope. */
   if (endofblock(ls->token) && ls->token != TK_until)
-    ls->vstack[idx].endpc = fs->bl->nactvar | VSTACK_LABEL;
+    ls->vstack[idx].slot = fs->bl->nactvar;
   gola_resolve(ls, fs->bl, idx);
 }

@@ -2519,7 +2524,7 @@ static int predict_next(LexState *ls, FuncState *fs, BCPos pc)
     name = gco2str(gcref(var_get(ls, fs, bc_d(ins)).name));
     break;
   case BC_UGET:
-    name = gco2str(gcref(ls->vstack[fs->uvloc[bc_d(ins)].vidx].name));
+    name = gco2str(gcref(ls->vstack[fs->uvmap[bc_d(ins)]].name));
     break;
   case BC_GGET:
     /* There's no inverse index (yet), so lookup the strings. */
--- a/src/lj_record.c
+++ b/src/lj_record.c
@@ -1808,12 +1808,10 @@ void lj_record_ins(jit_State *J)
       int diff;
       rec_comp_prep(J);
       diff = lj_record_objcmp(J, ra, rc, rav, rcv);
-      if (diff == 1 && (tref_istab(ra) || tref_isudata(ra))) {
-	/* Only check __eq if different, but the same type (table or udata). */
+      if (diff == 2 || !(tref_istab(ra) || tref_isudata(ra)))
+	rec_comp_fixup(J, J->pc, ((int)op & 1) == !diff);
+      else if (diff == 1)  /* Only check __eq if different, but same type. */
	rec_mm_equal(J, &ix, (int)op);
-	break;
-      }
-      rec_comp_fixup(J, J->pc, ((int)op & 1) == !diff);
     }
     break;
