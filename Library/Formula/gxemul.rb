class Gxemul < Formula
  desc "Framework for full-system computer architecture emulation."
  homepage "http://gxemul.sourceforge.net"
  url "http://gxemul.sourceforge.net/src/gxemul-0.6.0.1.tar.gz"
  sha256 "0790823d8d7f8848c98318ace829f7a0159a5f9b79d80bd8c367fb17014dcda9"

  depends_on :x11

  # Fixes some compilation errors when built using Clang.
  # Patch has been submitted to gxemul-devel.
  patch :DATA

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man
    system "./configure"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/gxemul -H")
    assert_match /Available machine types/, output
  end
end

__END__
diff -waurp gxemul-0.6.0.1.orig/src/components/cpu/M88K_CPUComponent.cc gxemul-0.6.0.1/src/components/cpu/M88K_CPUComponent.cc
--- gxemul-0.6.0.1.orig/src/components/cpu/M88K_CPUComponent.cc	2014-08-17 10:45:14.000000000 +0200
+++ gxemul-0.6.0.1/src/components/cpu/M88K_CPUComponent.cc	2015-10-03 16:10:08.000000000 +0200
@@ -337,7 +337,7 @@ int M88K_CPUComponent::GetDyntransICshif
 }
 
 
-void (*M88K_CPUComponent::GetDyntransToBeTranslated())(CPUDyntransComponent*, DyntransIC*) const
+void (*M88K_CPUComponent::GetDyntransToBeTranslated())(CPUDyntransComponent*, DyntransIC*)
 {
 	return instr_ToBeTranslated;
 }
diff -waurp gxemul-0.6.0.1.orig/src/components/cpu/MIPS_CPUComponent.cc gxemul-0.6.0.1/src/components/cpu/MIPS_CPUComponent.cc
--- gxemul-0.6.0.1.orig/src/components/cpu/MIPS_CPUComponent.cc	2014-08-17 10:45:14.000000000 +0200
+++ gxemul-0.6.0.1/src/components/cpu/MIPS_CPUComponent.cc	2015-10-03 16:10:48.000000000 +0200
@@ -327,7 +327,7 @@ int MIPS_CPUComponent::GetDyntransICshif
 }
 
 
-void (*MIPS_CPUComponent::GetDyntransToBeTranslated())(CPUDyntransComponent*, DyntransIC*) const
+void (*MIPS_CPUComponent::GetDyntransToBeTranslated())(CPUDyntransComponent*, DyntransIC*)
 {
 	bool mips16 = m_pc & 1? true : false;
 	return mips16? instr_ToBeTranslated_MIPS16 : instr_ToBeTranslated;
diff -waurp gxemul-0.6.0.1.orig/src/include/components/CPUDyntransComponent.h gxemul-0.6.0.1/src/include/components/CPUDyntransComponent.h
--- gxemul-0.6.0.1.orig/src/include/components/CPUDyntransComponent.h	2014-08-17 10:45:13.000000000 +0200
+++ gxemul-0.6.0.1/src/include/components/CPUDyntransComponent.h	2015-10-03 16:06:53.000000000 +0200
@@ -105,7 +105,7 @@ public:
 protected:
 	// Implemented by specific CPU families:
 	virtual int GetDyntransICshift() const = 0;
-	virtual void (*GetDyntransToBeTranslated())(CPUDyntransComponent* cpu, DyntransIC* ic) const = 0;
+	virtual void (*GetDyntransToBeTranslated())(CPUDyntransComponent* cpu, DyntransIC* ic) = 0;
 
 	void DyntransToBeTranslatedBegin(struct DyntransIC*);
 	bool DyntransReadInstruction(uint16_t& iword);
diff -waurp gxemul-0.6.0.1.orig/src/include/components/M88K_CPUComponent.h gxemul-0.6.0.1/src/include/components/M88K_CPUComponent.h
--- gxemul-0.6.0.1.orig/src/include/components/M88K_CPUComponent.h	2014-08-17 10:45:13.000000000 +0200
+++ gxemul-0.6.0.1/src/include/components/M88K_CPUComponent.h	2015-10-03 16:09:27.000000000 +0200
@@ -377,7 +377,7 @@ protected:
 	virtual bool FunctionTraceReturnImpl(int64_t& retval) { retval = m_r[M88K_RETURN_VALUE_REG]; return true; }
 
 	virtual int GetDyntransICshift() const;
-	virtual void (*GetDyntransToBeTranslated())(CPUDyntransComponent*, DyntransIC*) const;
+	virtual void (*GetDyntransToBeTranslated())(CPUDyntransComponent*, DyntransIC*);
 
 	virtual void ShowRegisters(GXemul* gxemul, const vector<string>& arguments) const;
 
diff -waurp gxemul-0.6.0.1.orig/src/include/components/MIPS_CPUComponent.h gxemul-0.6.0.1/src/include/components/MIPS_CPUComponent.h
--- gxemul-0.6.0.1.orig/src/include/components/MIPS_CPUComponent.h	2014-08-17 10:45:13.000000000 +0200
+++ gxemul-0.6.0.1/src/include/components/MIPS_CPUComponent.h	2015-10-03 16:10:34.000000000 +0200
@@ -196,7 +196,7 @@ protected:
 	virtual bool FunctionTraceReturnImpl(int64_t& retval);
 
 	virtual int GetDyntransICshift() const;
-	virtual void (*GetDyntransToBeTranslated())(CPUDyntransComponent*, DyntransIC*) const;
+	virtual void (*GetDyntransToBeTranslated())(CPUDyntransComponent*, DyntransIC*);
 
 	virtual void ShowRegisters(GXemul* gxemul, const vector<string>& arguments) const;
 
